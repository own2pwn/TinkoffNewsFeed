//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import Alamofire

enum CTNFNewsListProvider {
    static let API_HOST = "https://api.tinkoff.ru"
    static let API_VERSION = "v1"
    static let API_METHOD = "news"
    static let API_FETCH_PARAM_FIRST = "first"
    static let API_FETCH_PARAM_LAST = "last"

    static let API_REQUEST_METHOD = HTTPMethod.get
}

extension String {
    static let TNF_API_HOST = CTNFNewsListProvider.API_HOST
    static let TNF_API_NEWS_LIST_VERSION = CTNFNewsListProvider.API_VERSION
    static let TNF_API_NEWS_LIST_METHOD = CTNFNewsListProvider.API_METHOD
    static let TNF_API_NEWS_LIST_FETCH_PARAM_FIRST = CTNFNewsListProvider.API_FETCH_PARAM_FIRST
    static let TNF_API_NEWS_LIST_FETCH_PARAM_LAST = CTNFNewsListProvider.API_FETCH_PARAM_LAST
}

extension HTTPMethod {
    static let TNF_API_NEWS_LIST_REQUEST_METHOD = CTNFNewsListProvider.API_REQUEST_METHOD
}
