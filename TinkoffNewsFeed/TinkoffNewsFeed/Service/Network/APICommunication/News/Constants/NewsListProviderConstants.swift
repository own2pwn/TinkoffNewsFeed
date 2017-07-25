//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import Alamofire

enum CTNFNewsListProvider {
    static let API_METHOD = "news"
    static let API_FETCH_PARAM_FIRST = "first"
    static let API_FETCH_PARAM_LAST = "last"

    static let API_REQUEST_URL_FMT = "%@/%@/%@"
    static let API_REQUEST_QUERY_FMT = "?%@=%d&%@=%d"

    static let API_REQUEST_METHOD = HTTPMethod.get
}

extension String {
    static let TNF_API_NEWS_LIST_METHOD = CTNFNewsListProvider.API_METHOD
    static let TNF_API_NEWS_LIST_FETCH_PARAM_FIRST = CTNFNewsListProvider.API_FETCH_PARAM_FIRST
    static let TNF_API_NEWS_LIST_FETCH_PARAM_LAST = CTNFNewsListProvider.API_FETCH_PARAM_LAST

    static let TNF_API_NEWS_LIST_REQUEST_QUERY_FMT = CTNFNewsListProvider.API_REQUEST_QUERY_FMT
}

extension HTTPMethod {
    static let TNF_API_NEWS_LIST_REQUEST_METHOD = CTNFNewsListProvider.API_REQUEST_METHOD
}
