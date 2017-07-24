//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import SwiftyJSON

final class NewsListParser: IParser<[NewsEntityModel], JSON> {
    override func parse(_ response: JSON) -> [NewsEntityModel]? {

        let resultCode = response[NEWS_LIST_STATUS_CODE_KEY].string ?? "nil"
        if resultCode != EXPECTED_STATUS_CODE {
            log.warning("API response status code: \(resultCode) | Received data may be wrong!")
        }

        var newsModel = [NewsEntityModel]()
        let payload = response[NEWS_LIST_PAYLOAD_KEY].arrayValue

        for news in payload {
            let info = news.dictionary
            
        }

        return nil
    }

    // MARK: - Private
    
    private func mapJSON(_ json: JSON) -> NewsEntityModel? {
    }

    private typealias JSONType = [String: Any]

    // MARK: - Constants

    private let EXPECTED_STATUS_CODE = "OK"

    private let NEWS_LIST_PAYLOAD_KEY = "resultCode"
    private let NEWS_LIST_STATUS_CODE_KEY = "resultCode"
}
