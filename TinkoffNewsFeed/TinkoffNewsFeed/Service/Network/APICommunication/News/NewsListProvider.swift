//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

private struct NewsListAPIResponse {
    let statusCode: String
    //let payload:
}

struct NewsListAPIModel {
    let newsId: String
    let title: String
    let publicationDate: String
}

final class NewsListProvider: INewsListProvider {
    func load(offset: Int = 0, count: Int,
              completion: ([NewsListAPIModel]?) -> Void) {

    }

    private func constructRequest(offset: Int, count: Int) -> URLRequest {
        // "https://api.tinkoff.ru/v1/news?last=2"
        let queryFmt = "%@/%@/%@?%@=%d&%@=%d"
        let query = String(format: queryFmt, apiHost, apiVersion, apiMethod,
                apiFetchFrom, offset, apiFetchTo, count)
    }

    init(newsCacheManager: INewsListCacheManager) {
        cacheManager = newsCacheManager
    }

    private let cacheManager: INewsListCacheManager

    private let apiHost = "https://api.tinkoff.ru"
    private let apiVersion = "v1"
    private let apiMethod = "news"
    private let apiFetchFrom = "first"
    private let apiFetchTo = "last"
}
