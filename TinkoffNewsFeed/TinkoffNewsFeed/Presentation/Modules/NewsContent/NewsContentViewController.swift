//
//  NewsContentViewController.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 25.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit
import PullToRefreshSwift

class NewsContentViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    // MARK: - Setup
    
    private func setupController() {
        // contentTextView.addPullToRefresh(refreshCompletion: nil)
        loadContent()
    }
    
    // TODO: use protocol
    
    private func buildContentProvider() -> NewsContentProvider {
        let provider = NewsContentProvider()
        
        return provider
    }
    
    private var contentProvider: NewsContentProvider!
    
    private func loadContent() {
        
        // TODO: status bar activity indicator
        loadingIndicator.startAnimating()
        
        contentProvider = buildContentProvider()
        contentProvider.load(by: newsId) { (content) in
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    strongSelf.loadingIndicator.stopAnimating()
                    let loadedContent = content.content.decodeHTMLToAttributed()!
                    let mainContent = strongSelf.makeMainContent(loadedContent)
                    
                    let newContent = NSMutableAttributedString()
                    newContent.append(strongSelf.currentContent)
                    newContent.append(mainContent)
                    
                    strongSelf.currentContent = newContent
                }
            }
        }
        
        let heading = makeHeading(newsTitle)
        currentContent = heading
    }
    
    private func makeHeading(_ string: String) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = .natural
        
        let attr = [NSFontAttributeName : UIFont.helveticaBold(17.0),
                    NSParagraphStyleAttributeName: style]
        
        let newsContent = string + "\n\n"
        let heading = NSAttributedString(string: newsContent, attributes: attr)
        
        return heading
    }
    
    private func makeMainContent(_ string: NSAttributedString) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.paragraphSpacing = 10.0
        
        let attr = [NSFontAttributeName : UIFont.helvetica(17.0),
                    NSParagraphStyleAttributeName: style]
        
        let nsContent = string.string as NSString
        let range = NSMakeRange(0, nsContent.length)
        let content = NSMutableAttributedString(attributedString: string)
        content.addAttributes(attr, range: range)
        
        return content
    }
    
    // MARK: - Members
    
    var newsId: String!
    var newsTitle: String!
    
    private var currentContent: NSAttributedString! {
        didSet {
            contentTextView.attributedText = currentContent
        }
    }
}
