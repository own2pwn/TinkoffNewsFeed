//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol INewsListCacheManager {
    
    // func updateCache(for news: [NewsEntityModel])
    
    func cache(_ data: NewsListAPIModel)
}