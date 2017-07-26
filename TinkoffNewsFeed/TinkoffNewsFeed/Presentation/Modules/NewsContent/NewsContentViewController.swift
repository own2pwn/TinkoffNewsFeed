//
//  NewsContentViewController.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 25.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit
import PullToRefreshSwift

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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupController()
        setupView()
        loadContent()
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

    // MARK: - DI

    let assembler = NewsContentAssembler.self

    var model: INewsContentModel!

    // MARK: - Methods

    private func setupController() {
        let d = assembler.assembly()
        model = d.model
    }

    private func setupView() {
        contentTextView.addPullToRefresh(refreshCompletion: onUpdate)
    }

    private func loadContent() {
        if newsContent == nil {
            log.debug("using api to load news content")
            // TODO: set model view
            // model.view = self
            model.loadNewsContent(by: newsId)
        } else {
            displayNewsTitle()
            present(newsContent!)
        }
    }

    private func onUpdate() {
        // TODO: upd content
        contentTextView.stopPullRefreshing()
    }

    private func present(_ content: String) {
        let parsed = content.decodeHTMLToAttributed()!
        let mainContent = makeMainContent(parsed)

        let newContent = NSMutableAttributedString()
        newContent.append(currentContent)
        newContent.append(mainContent)

        currentContent = newContent
    }

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

    // TODO: use protocol

    private func buildContentProvider() -> INewsContentProvider {
        let provider = NewsContentProvider()

        return provider
    }

    private var contentProvider: INewsContentProvider!

    // MARK: - Content presentation

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
