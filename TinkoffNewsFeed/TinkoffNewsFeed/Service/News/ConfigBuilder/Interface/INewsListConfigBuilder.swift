//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol INewsListConfigBuilder {
    func build(offset: Int, count: Int) -> RequestConfig<NewsListAPIModel, JSON>
}
