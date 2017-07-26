//
// Created by Evgeniy on 25.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

enum CTNFNewsListParser {
    static let RESPONSE_ID_KEY = "id"
    static let RESPONSE_TITLE_KEY = "text"
    static let RESPONSE_PUB_DATE_KEY = "publicationDate"
    static let RESPONSE_PUB_DATE_KEY_PATH = "publicationDate.milliseconds"
}

extension String {
    static let TNF_API_NEWS_LIST_RESPONSE_ID_KEY = CTNFNewsListParser.RESPONSE_ID_KEY
    static let TNF_API_NEWS_LIST_RESPONSE_TITLE_KEY = CTNFNewsListParser.RESPONSE_TITLE_KEY
    static let TNF_API_NEWS_LIST_RESPONSE_PUB_DATE_KEY = CTNFNewsListParser.RESPONSE_PUB_DATE_KEY
    static let TNF_API_NEWS_LIST_RESPONSE_PUB_DATE_KEY_PATH = CTNFNewsListParser.RESPONSE_PUB_DATE_KEY_PATH
}
