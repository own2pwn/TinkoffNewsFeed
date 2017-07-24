//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

final class NewsListParser: IParser<[NewsEntityModel], JSON> {
    override func parse(_ response: JSON) -> [NewsEntityModel]? {

        let resultCode = response[NEWS_LIST_STATUS_CODE_KEY].string ?? "nil"
        if resultCode != EXPECTED_STATUS_CODE {
            log.warning("API response status code: \(resultCode) | Received data may be wrong!")
        }

        var newsModel = [NewsEntityModel]()
        let payload = response[NEWS_LIST_PAYLOAD_KEY].arrayValue

        for single in payload {
            let single = single.rawValue as! JSONType
            if let model = NewsEntityModel(JSON: single) {
                newsModel.append(model)
            }
        }

        return nil
    }

    // MARK: - Private

    private func mapJSON(_ json: JSON) -> NewsEntityModel? {
        return nil
    }

    private typealias JSONType = [String: Any]

    // MARK: - Constants

    private let EXPECTED_STATUS_CODE = "OK"

    private let NEWS_LIST_PAYLOAD_KEY = "payload"
    private let NEWS_LIST_STATUS_CODE_KEY = "resultCode"
}


//let id: String
//let pubDate: Date
//let title: String
//let titleHash: String

extension NewsEntityModel: Mappable {
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    init?(map: Map) {
        let json = JSON(map.JSON)
        let id = json["id"].string
        let title = json["text"].string

        if let id = id, let title = title {
            self.id = id
            self.pubDate = Date()
            self.title = title
            titleHash = "\(arc4random_uniform(100_000_000))" // todo: hash
        } else {
            return nil
        }

        //let model = NewsEntityModel(id: id!, pubDate: pubDate_fake, title: title!, titleHash: titleHash)

        //return model
    }

    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    mutating func mapping(map: Map) {

        // let pubDate = json["publicationDate"]["milliseconds"] // cast to date

        id <- map["id"]
        // pubDate <- map["publicationDate"]["milliseconds"]
        title <- map["text"]
        titleHash = "\(arc4random_uniform(100_000_000))" // todo: hash
        pubDate = Date()
    }
}
