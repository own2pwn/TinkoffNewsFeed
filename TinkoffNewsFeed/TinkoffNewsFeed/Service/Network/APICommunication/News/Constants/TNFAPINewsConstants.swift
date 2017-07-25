//
// Created by Evgeniy on 25.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

enum CTNFAPINews {
    static let API_HOST = "https://api.tinkoff.ru"
    static let API_VERSION = "v1"
    static let API_REQUEST_URL_FMT = "%@/%@/%@"
}

extension String {
    static let TNF_API_HOST = CTNFAPINews.API_HOST
    static let TNF_API_NEWS_VERSION = CTNFAPINews.API_VERSION
    static let TNF_API_NEWS_REQUEST_URL_FMT = CTNFAPINews.API_REQUEST_URL_FMT
}
