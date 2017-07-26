//
// Created by Evgeniy on 25.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import Alamofire

enum CTNFNewsContentProvider {
    static let API_METHOD = "news_content"
    static let API_FETCH_PARAM_ID = "id"

    static let API_REQUEST_QUERY_FMT = "?%@=%@"

    static let API_REQUEST_METHOD = HTTPMethod.get
}

extension String {
    static let TNF_API_NEWS_CONTENT_METHOD = CTNFNewsContentProvider.API_METHOD
    static let TNF_API_NEWS_CONTENT_PARAM_ID = CTNFNewsContentProvider.API_FETCH_PARAM_ID
    static let TNF_API_NEWS_CONTENT_REQUEST_QUERY_FMT = CTNFNewsContentProvider.API_REQUEST_QUERY_FMT
}

extension HTTPMethod {
    static let TNF_API_NEWS_CONTENT_REQUEST_METHOD = CTNFNewsContentProvider.API_REQUEST_METHOD
}