//
//  INewsContentConfigBuilder.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 26.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol INewsContentConfigBuilder {
    func build(_ id: String) -> RequestConfig<NewsContentAPIModel, JSON>
}
