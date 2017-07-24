//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import Alamofire

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
        let urlFmt = "%@/%@/%@"
        let url = String(format: urlFmt, apiHost, apiVersion, apiMethod)

        let queryFmt = "?%@=%d&%@=%d"
        let query = String(format: queryFmt, apiFetchFrom, offset, apiFetchTo, count)

        let endpoint = url + query
        let request = try! URLRequest(url: endpoint, method: apiRequestMethod)

        return request
    }

    // MARK: - DI
    
    init(cacheManager: INewsListCacheManager, requestSender: IRequestSender) {
        self.cacheManager = cacheManager
        self.requestSender = requestSender
    }

    private let requestSender: IRequestSender
    private let cacheManager: INewsListCacheManager

    // MARK: - Constants

    private let apiHost: String = .TNF_API_HOST
    private let apiVersion: String = .TNF_API_NEWS_LIST_VERSION
    private let apiMethod: String = .TNF_API_NEWS_LIST_METHOD
    private let apiFetchFrom: String = .TNF_API_NEWS_LIST_FETCH_PARAM_FIRST
    private let apiFetchTo: String = .TNF_API_NEWS_LIST_FETCH_PARAM_LAST
    private let apiRequestMethod: HTTPMethod = .TNF_API_NEWS_LIST_REQUEST_METHOD
}
