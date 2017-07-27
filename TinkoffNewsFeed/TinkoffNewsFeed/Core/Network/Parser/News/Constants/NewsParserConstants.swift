//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

enum CTNFNewsParser {
    static let RESPONSE_STATUS_CODE_KEY = "resultCode"
    static let RESPONSE_PAYLOAD_KEY = "payload"
    static let RESPONSE_PUB_DATE_KEY_TIME = "milliseconds"
}

enum TNFAPINewsTimeFormat: Double {
    case milliseconds = 1000.0
}

extension String {
    static let TNF_API_NEWS_RESPONSE_STATUS_CODE_KEY = CTNFNewsParser.RESPONSE_STATUS_CODE_KEY
    static let TNF_API_NEWS_RESPONSE_PAYLOAD_KEY = CTNFNewsParser.RESPONSE_PAYLOAD_KEY
    static let TNF_API_NEWS_RESPONSE_MS_KEY = CTNFNewsParser.RESPONSE_PUB_DATE_KEY_TIME
}