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
        contentTextView.addPullToRefresh(refreshCompletion: nil)
        loadContent()
    }
    
    private func loadContent() {
        
        loadingIndicator.startAnimating()
        
        let style = NSMutableParagraphStyle()
        style.alignment = .natural
        let attr = [NSFontAttributeName : UIFont.helveticaBold(17.0),
                    NSParagraphStyleAttributeName: style]
        
        let newsContent = newsTitle + "\n\n"
        let content = NSAttributedString(string: newsContent, attributes: attr)
        contentTextView.attributedText = content
    }
    
    // MARK: - Members
    
    var newsId: String!
    var newsTitle: String!
}
