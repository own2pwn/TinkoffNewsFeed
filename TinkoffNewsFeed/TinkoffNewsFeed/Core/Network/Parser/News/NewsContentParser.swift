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

    override func propertyMapping() -> [(keyInObject: String?, keyInResource: String?)] {
        let mapping: [(keyInObject: String?, keyInResource: String?)] =
                [(keyInObject: "createdAt", keyInResource: "creationDate.milliseconds"),
                 (keyInObject: "modifiedAt", keyInResource: "lastModificationDate.milliseconds")]

        return mapping
    }
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        if key == contentCreatedAtKey {
            let value = value as! [String: Double]
            let time = value[msKey]!
            let date = Date(timeIntervalSince1970: (time / 1000.0))
            createdAt = date
        }
        
        if key == contentModifiedAtKey {
            let value = value as! [String: Double]
            let time = value[msKey]!
            let date = Date(timeIntervalSince1970: (time / 1000.0))
            modifiedAt = date
        }
    }
    
    // MARK: - Constants
    
    private let contentCreatedAtKey = "creationDate"
    private let contentModifiedAtKey = "lastModificationDate"
    private let msKey = "milliseconds"
}

final class NewsContentParser: IParser<NewsContentAPIModel, JSON> {
    override func parse(_ response: JSON) -> NewsContentAPIModel? {
        //let response = response.rawValue as! String
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
