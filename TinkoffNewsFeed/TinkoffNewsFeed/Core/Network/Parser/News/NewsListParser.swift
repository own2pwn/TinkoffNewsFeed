//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import SwiftyJSON
import EVReflection

final class NewsListAPIModel: EVObject {
    var resultCode = ""
    var payload: [NewsListPayload]? = []
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {}
}

final class NewsListPayload: EVObject, IEntityMappable {
    var id = ""
    var title = ""
    var pubDate = Date()
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        if key == newsPubDateKey {
            let value = value as! [String: Double]
            let time = value[msKey]!
            let date = convertTimeToDate(time)
            pubDate = date
        }
        
        if key == newsTitleKey {
            title = value as! String
        }
    }
    
    private func convertTimeToDate(_ time: Double) -> Date {
        let date = Date(timeIntervalSince1970: (time / timeFormat))
        
        return date
    }
    
    // MARK: - Constants
    
    private let newsPubDateKey: String = .TNF_API_NEWS_LIST_RESPONSE_PUB_DATE_KEY
    private let newsTitleKey: String = .TNF_API_NEWS_LIST_RESPONSE_TITLE_KEY
    private let msKey: String = .TNF_API_NEWS_RESPONSE_MS_KEY
    private let timeFormat = TNFAPINewsTimeFormat.milliseconds.rawValue
}

final class NewsListParser: IParser<NewsListAPIModel, JSON> {
    override func parse(_ response: JSON) -> NewsListAPIModel? {
        let json = response.rawString(.utf8, options: [])
        let apiModel = NewsListAPIModel(json: json)
        
        let statusCode = apiModel.resultCode
        verifyResponseCode(statusCode)
        
        return apiModel
    }
    
    // MARK: - Private
    
    private func verifyResponseCode(_ code: String) {
        if code != expectedCode {
            log.warning("API response status code: \(code) | expected: \(expectedCode)")
            log.warning("Received data may be wrong!")
        }
    }
    
    // MARK: - Constants
    
    private let expectedCode: String = .TNF_API_NEWS_RESPONSE_CODE_OK
}
