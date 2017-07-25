//
// Created by Evgeniy on 25.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

enum CTNFNewsListParser {
    static let RESPONSE_STATUS_CODE_KEY = "resultCode"
    static let RESPONSE_EXPECTED_STATUS_CODE = "OK"

    static let RESPONSE_PAYLOAD_KEY = "payload"
    static let RESPONSE_ID_KEY = "id"
    static let RESPONSE_TITLE_KEY = "text"
    static let RESPONSE_PUB_DATE_KEY_PATH = "publicationDate.milliseconds"
}

enum TNFNewsListAPITimeFormat: Double {
    case millisecs = 1000.0
}

extension String {
    static let TNF_API_NEWS_LIST_RESPONSE_STATUS_CODE_KEY = CTNFNewsListParser.RESPONSE_STATUS_CODE_KEY
    static let TNF_API_NEWS_LIST_RESPONSE_EXPECTED_STATUS_CODE = CTNFNewsListParser.RESPONSE_EXPECTED_STATUS_CODE

    static let TNF_API_NEWS_LIST_RESPONSE_PAYLOAD_KEY = CTNFNewsListParser.RESPONSE_PAYLOAD_KEY
    static let TNF_API_NEWS_LIST_RESPONSE_ID_KEY = CTNFNewsListParser.RESPONSE_ID_KEY
    static let TNF_API_NEWS_LIST_RESPONSE_TITLE_KEY = CTNFNewsListParser.RESPONSE_TITLE_KEY
    static let TNF_API_NEWS_LIST_RESPONSE_PUB_DATE_KEY_PATH = CTNFNewsListParser.RESPONSE_PUB_DATE_KEY_PATH
}
