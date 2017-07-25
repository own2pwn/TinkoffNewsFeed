//
//  NewsContentViewController.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 25.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

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
        loadContent()
    }
    
    private func loadContent() {
        
        let style = NSMutableParagraphStyle()
        style.alignment = .natural
        let attr = [NSFontAttributeName : UIFont.helveticaBold(17.0),
                    NSParagraphStyleAttributeName: style]
        
        let content = NSAttributedString(string: newsTitle, attributes: attr)
        contentTextView.attributedText = content
    }
    
    // MARK: - Members
    
    var newsTitle: String!
}
