//
// Created by Evgeniy on 25.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import SwiftyJSON
import EVReflection

final class NewsContentAPIModel: EVObject {
    var resultCode = ""
    var payload: NewsContentPayload?

    override func setValue(_ value: Any!, forUndefinedKey key: String) {}
}

final class NewsContentPayload: EVObject, IEntityMappable {
    var content = ""
    var createdAt = Date()
    var modifiedAt = Date()

    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        if key == contentCreatedAtKey {
            let value = value as! [String: Double]
            let time = value[msKey]!
            let date = convertTimeToDate(time)
            createdAt = date
        }

        if key == contentModifiedAtKey {
            let value = value as! [String: Double]
            let time = value[msKey]!
            let date = convertTimeToDate(time)
            modifiedAt = date
        }
    }

    private func convertTimeToDate(_ time: Double) -> Date {
        let date = Date(timeIntervalSince1970: (time / timeFormat))

        return date
    }

    // MARK: - Constants

    private let contentCreatedAtKey = "creationDate"
    private let contentModifiedAtKey = "lastModificationDate"
    private let msKey: String = .TNF_API_NEWS_RESPONSE_MS_KEY
    private let timeFormat = TNFAPINewsTimeFormat.milliseconds.rawValue
}

final class NewsContentParser: IParser<NewsContentAPIModel, JSON> {
    override func parse(_ response: JSON) -> NewsContentAPIModel? {
        let json = response.rawString(.utf8, options: [])
        let apiModel = NewsContentAPIModel(json: json)

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
