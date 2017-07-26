//
//  NewsContentViewController.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 25.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit
import PullToRefreshSwift
import PKHUD
import ReachabilitySwift

struct NewsContentDependencies {
    let model: INewsContentModel
}

protocol NewsContentViewDelegate: class {
    func startLoadingAnimation()
    func stopLoadingAnimation()
    
    func present(_ content: NewsContentDisplayModel)
}

final class NewsContentViewController: UIViewController, NewsContentViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    // MARK: - Overrides
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        observeReachability()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        injectDependencies()
        setupView()
        loadContent()
    }
    
    deinit {
        reachability.stopNotifier()
    }
    
    // MARK: - NewsContentViewDelegate
    
    func startLoadingAnimation() {
        setLoadingEnabled(true)
    }
    
    func stopLoadingAnimation() {
        setLoadingEnabled(false)
    }
    
    func present(_ content: NewsContentDisplayModel) {
        let error = content.error
        if error {
            log.warning(content.content)
            showError(title: noConnectionTitle, subtitle: noConnectionSubtitle)
        } else {
            let loadedContent = content.content
            present(loadedContent)
        }
    }
    
    // MARK: - DI
    
    var model: INewsContentModel!
    
    var assembler: INewsContentDependencyManager!
    
    private func injectDependencies() {
        model = assembler.newsContenModel()
    }
    
    // MARK: - Members
    
    var newsId: String!
    var newsTitle: String!
    var newsContent: String?
    
    let reachability = Reachability(hostname: "api.tinkoff.ru")!
    
    // MARK: - Constants
    
    private let noConnectionTitle = "Error while loading news"
    private let noConnectionSubtitle = "Check your internet connection?"
    private let hudFlashDelay = 1.0
    
    // MARK: - Methods
    
    private func observeReachability() {
        try? reachability.startNotifier()
        reachability.whenReachable = onActiveConnection
        reachability.whenUnreachable = onLostConnection
    }
    
    private func showError(title: String? = nil, subtitle: String? = nil) {
        let hudContent: HUDContentType = .labeledError(title: title, subtitle: subtitle)
        HUD.flash(hudContent, delay: hudFlashDelay)
    }
    
    private func onActiveConnection(_ info: Reachability) {
        DispatchQueue.main.async { [weak self] in
            if self?.newsContent == nil {
                if let newsId = self?.newsId {
                    self?.model.loadNewsContent(by: newsId)
                }
            }
        }
    }
    
    private func onLostConnection(_ info: Reachability) {
        DispatchQueue.main.async { [weak self] in
            self?.showError(title: "No internet connection")
        }
    }
    
    private func setupView() {
        model.view = self
        contentTextView.addPullToRefresh(refreshCompletion: onUpdate)
    }
    
    private func onUpdate() {
        // TODO: upd content
        contentTextView.stopPullRefreshing()
    }
    
    private var currentContent: NSAttributedString! {
        didSet {
            contentTextView.attributedText = currentContent
        }
    }
    
    // MARK: - Content presentation
    
    private func loadContent() {
        displayNewsTitle()
        if newsContent == nil {
            log.debug("using api to load news content")
            model.loadNewsContent(by: newsId)
        } else {
            present(newsContent!)
        }
    }
    
    private func present(_ content: String) {
        let parsed = content.decodeHTMLToAttributed()!
        let mainContent = makeMainContent(parsed)
        
        let newContent = NSMutableAttributedString()
        newContent.append(currentContent)
        newContent.append(mainContent)
        
        currentContent = newContent
    }
    
    private func displayNewsTitle() {
        let heading = makeHeading(newsTitle)
        currentContent = heading
    }
    
    private func makeHeading(_ string: String) -> NSAttributedString {
        let font = UIFont.helveticaBold(17.0)
        let style = NSMutableParagraphStyle()
        style.alignment = .natural
        
        let attr = buildFontAttributes(font, style)
        
        let newsContent = string + "\n\n"
        let heading = NSAttributedString(string: newsContent, attributes: attr)
        
        return heading
    }
    
    private func makeMainContent(_ string: NSAttributedString) -> NSAttributedString {
        let font = UIFont.helvetica(17.0)
        let style = NSMutableParagraphStyle()
        style.paragraphSpacing = 10.0
        
        let attr = buildFontAttributes(font, style)
        let range = string.makeRange()
        
        let content = NSMutableAttributedString(attributedString: string)
        content.addAttributes(attr, range: range)
        
        return content
    }
    
    // MARK: - View
    
    private func setLoadingEnabled(_ state: Bool) {
        DispatchQueue.main.async { [weak self] in
            UIApplication.shared.isNetworkActivityIndicatorVisible = state
            if state {
                self?.loadingIndicator.startAnimating()
            } else {
                self?.loadingIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - Helpers
    
    private func buildFontAttributes(_ font: UIFont, _ style: NSMutableParagraphStyle) -> [String: NSObject] {
        let attr = [NSFontAttributeName: font,
                    NSParagraphStyleAttributeName: style]
        
        return attr
    }
}
