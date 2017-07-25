//
//  NewsFeedCell.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 24.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

final class NewsFeedCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var newsDateLabel: UILabel!
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    
    @IBOutlet weak var newsViewsCountLabel: UILabel!
    
    // MARK: - Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
