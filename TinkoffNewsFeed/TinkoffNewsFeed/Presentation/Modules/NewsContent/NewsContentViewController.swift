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
    
    // MARK: - Overrides
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        observeReachability()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        injectDependencies()
        setupView()
    }
    
    deinit {
        reachability.stopNotifier()
    }
    
    // MARK: - Private
    
    // MARK: Constants
    
    private let hudFlashDelay = 1.0
    
    private let noConnectionTitle = "Error while loading news"
    private let noConnectionSubtitle = "Check your internet connection?"
    
    // MARK: - Instance Members
    
    let reachability = Reachability(hostname: "api.tinkoff.ru")!
    
    var newsId: String!
    var newsTitle: String!
    var newsContent: String?
    
    private var currentContent: NSAttributedString! {
        didSet {
            contentTextView.attributedText = currentContent
        }
    }
    
    private var isInternetAvailable = false
    
    // MARK: - Controller
    
    private func observeReachability() {
        try? reachability.startNotifier()
        reachability.whenReachable = onActiveConnection
        reachability.whenUnreachable = onLostConnection
    }
    
    private func onActiveConnection(_ info: Reachability) {
        isInternetAvailable = true
        DispatchQueue.main.async { [weak self] in
            self?.loadContent()
        }
    }
    
    private func onLostConnection(_ info: Reachability) {
        isInternetAvailable = false
        DispatchQueue.main.async { [weak self] in
            self?.showError(title: "No internet connection")
        }
    }
    
    // MARK: - View
    
    private func setupView() {
        model.view = self
        contentTextView.addPullToRefresh(refreshCompletion: onUpdate)
    }
    
    private func showError(title: String? = nil, subtitle: String? = nil) {
        let hudContent: HUDContentType = .labeledError(title: title, subtitle: subtitle)
        HUD.flash(hudContent, delay: hudFlashDelay)
    }
    
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
    
    // MARK: - Content presentation
    
    private func loadContent() {
        displayNewsTitle()
        if newsContent == nil {
            log.debug("using api to load news content")
            model.loadNewsContent(by: newsId, completion: { [weak self] error in
                if let e = error {
                    self?.showError(title: "Can't update news content!", subtitle: e)
                } else {
                    self?.displayNewsTitle()
                }
            })
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
        newsContent = content
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
    
    // MARK: - Utilities
    
    private func onUpdate() {
        if isInternetAvailable {
            log.debug("using api to load news content")
            model.loadNewsContent(by: newsId) { [weak self] error in
                if let e = error {
                    self?.showError(title: "Can't update news content!", subtitle: e)
                } else {
                    self?.displayNewsTitle()
                }
                self?.contentTextView.stopPullRefreshing()
            }
        } else {
            contentTextView.stopPullRefreshing()
            showError(title: "Can't update news content!", subtitle: "No internet connection available!")
        }
    }
    
    private func buildFontAttributes(_ font: UIFont, _ style: NSMutableParagraphStyle) -> [String: NSObject] {
        let attr = [NSFontAttributeName: font,
                    NSParagraphStyleAttributeName: style]
        
        return attr
    }
    
    // MARK: - DI
    
    var model: INewsContentModel!
    
    var assembler: INewsContentDependencyManager!
    
    private func injectDependencies() {
        model = assembler.newsContentModel()
    }
}
