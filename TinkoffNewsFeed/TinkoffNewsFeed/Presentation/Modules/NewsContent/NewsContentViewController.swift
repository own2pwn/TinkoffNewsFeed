//
//  NewsContentViewController.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 25.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit
import PullToRefreshSwift


/**
 
 If `error` is `true` then `content` is error message to be shown to user
 
 Else news content stored in `content`
*/

struct NewsContentDisplayModel {
    let error: Bool
    let content: String
}

protocol NewsContentViewDelegate: class {
    func startLoadingAnimation()
    func stopLoadingAnimation()

    func present(_ content: NewsContentDisplayModel)
}

protocol INewsContentModel: class {
    weak var view: NewsContentViewDelegate! { get set }
    func loadNewsContent(by id: String, completion: (() -> Void)?)
}

extension INewsContentModel {
    func loadNewsContent(by id: String, completion: (() -> Void)? = nil) {
        loadNewsContent(by: id, completion: completion)
    }
}

final class NewsContentModel: INewsContentModel {

    // MARK: - Members

    weak var view: NewsContentViewDelegate!

    // MARK: - INewsContentModel

    func loadNewsContent(by id: String, completion: (() -> Void)? = nil) {
        view.startLoadingAnimation()
        contentProvider.load(by: id) { [weak self] (displayModel) in
            completion?()
            self?.view.stopLoadingAnimation()
            self?.view.present(displayModel)
        }
    }

    // MARK: - DI

    init(contentProvider: INewsContentProvider) {
        self.contentProvider = contentProvider
    }

    private let contentProvider: INewsContentProvider
}

final class NewsContentViewController: UIViewController, NewsContentViewDelegate {

    // MARK: - Outlets

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    @IBOutlet weak var contentTextView: UITextView!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        setupController()
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
            // TODO: show error to user
        } else {
            let loadedContent = content.content
            present(loadedContent)
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

    // MARK: - Members

    var model: INewsContentModel!

    private func inejctModel() -> INewsContentModel {
        let contentProvider = buildContentProvider()
        let model = NewsContentModel(contentProvider: contentProvider)

        return model
    }

    var newsId: String!
    var newsTitle: String!
    var newsContent: String?

    private var currentContent: NSAttributedString! {
        didSet {
            contentTextView.attributedText = currentContent
        }
    }

    // MARK: - Setup

    private func setupController() {
        contentTextView.addPullToRefresh(refreshCompletion: nil)

        //TODO: model.loadContent(_ id:)
        
        if newsContent == nil {
            log.debug("using api to load news content")
            loadContent()
        } else {
            displayNewsTitle()
            present(newsContent!)
        }
    }

    // TODO: use protocol

    private func buildContentProvider() -> INewsContentProvider {
        let provider = NewsContentProvider()

        return provider
    }

    private var contentProvider: INewsContentProvider!

    private func loadContent() {
        
        displayNewsTitle()
        
        model = inejctModel()
        model.view = self

        model.loadNewsContent(by: newsId)
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

    // MARK: - Helpers

    private func buildFontAttributes(_ font: UIFont, _ style: NSMutableParagraphStyle) -> [String: NSObject] {
        let attr = [NSFontAttributeName: font,
                    NSParagraphStyleAttributeName: style]

        return attr
    }
}
