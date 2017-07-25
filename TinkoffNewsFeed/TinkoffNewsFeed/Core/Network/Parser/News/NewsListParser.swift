//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper
import CryptoSwift

// TODO: let parser to save all right away to core data

class NewsListParser: IParser<[NewsEntityModel], JSON> {
    override func parse(_ response: JSON) -> [NewsEntityModel]? {
        let resultCode = response[statusCodeKey].string ?? "nil"
        verifyResponseCode(resultCode)

        var newsList = [NewsEntityModel]()
        let payload = response[payloadKey].arrayValue

        for single in payload {
            let single = single.rawValue as! JSONDict
            if let news = NewsEntityModel(JSON: single) {
                newsList.append(news)
            }
        }

        return newsList
    }

    // MARK: - Private

    private func verifyResponseCode(_ code: String) {
        if code != exStatusCode {
            log.warning("API response status code: \(code) | expected: \(exStatusCode)")
            log.warning("Received data may be wrong!")
        }
    }

    private typealias JSONDict = [String: Any]

    // MARK: - Constants

    private let exStatusCode: String = .TNF_API_NEWS_LIST_RESPONSE_EXPECTED_STATUS_CODE
    private let statusCodeKey: String = .TNF_API_NEWS_LIST_RESPONSE_STATUS_CODE_KEY
    private let payloadKey: String = .TNF_API_NEWS_LIST_RESPONSE_PAYLOAD_KEY
}

extension NewsEntityModel: Mappable {
    init?(map: Map) {
        let json = JSON(map.JSON)
        
        let id = json[NewsEntityModel.idKey].string
        let title = json[NewsEntityModel.titleKey].string
        let pubTime = json[NewsEntityModel.pubDateKey][NewsEntityModel.pubDateKeyTime].double
        let pubDate = NewsEntityModel.convertTimeToDate(pubTime)
        let hash = title?.sha1()

        if let id = id, let title = title, let pubDate = pubDate, let hash = hash {
            self.id = id
            self.pubDate = pubDate
            self.title = title
            self.titleHash = hash
        } else {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {}
    
    private static func convertTimeToDate(_ time: Double?) -> Date? {
        guard let time = time else {
            return nil
        }
        
        let date = Date(timeIntervalSince1970: (time / timeFormat))
        
        return date
    }
    
    // MARK: - Constants
    private static let idKey: String = .TNF_API_NEWS_LIST_RESPONSE_ID_KEY
    private static let titleKey: String = .TNF_API_NEWS_LIST_RESPONSE_TITLE_KEY
    private static let pubDateKey: String = .TNF_API_NEWS_LIST_RESPONSE_PUB_DATE_KEY
    private static let pubDateKeyTime: String = .TNF_API_NEWS_LIST_RESPONSE_PUB_DATE_KEY_TIME
    private static let timeFormat = TNFNewsListAPITimeFormat.millisecs.rawValue
}
