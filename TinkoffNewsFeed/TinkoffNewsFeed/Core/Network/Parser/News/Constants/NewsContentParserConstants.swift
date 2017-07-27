//
//  NewsContentParserConstants.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 27.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

enum CTNFNewsContentParser {
    static let RESPONSE_CREATED_AT_KEY = "creationDate"
    static let RESPONSE_MODIFIED_AT_KEY = "lastModificationDate"
}

extension String {
    static let TNF_API_NEWS_CONTENT_RESPONSE_CREATION_DATE_KEY = CTNFNewsContentParser.RESPONSE_CREATED_AT_KEY
    static let TNF_API_NEWS_CONTENT_RESPONSE_MODIFICATION_DATE_KEY = CTNFNewsContentParser.RESPONSE_MODIFIED_AT_KEY
}
