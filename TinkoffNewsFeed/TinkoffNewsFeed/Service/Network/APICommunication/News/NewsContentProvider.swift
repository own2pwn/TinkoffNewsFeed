//
// Created by Evgeniy on 25.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import Alamofire

class NewsContentProvider: INewsContentProvider {
    func load(by id: String, completion: (String) -> Void) {
    }

    // MARK: - Private

    private func buildRequestConfig(_ id: String) {
        let request = buildRequest(id)
        let parser =
    }

    private func buildRequest(_ id: String) -> URLRequest {

        // "https://api.tinkoff.ru/v1/news_content?id=8964"

        let url = String(format: urlFmt, apiHost, apiVersion, apiMethod)
        let query = String(format: queryFmt, apiIdParam, id)
        let endpoint = url + query

        let request = try! URLRequest(url: endpoint, method: apiRequestMethod)

        return request
    }

    private let apiHost: String = .TNF_API_HOST
    private let apiVersion: String = .TNF_API_NEWS_VERSION
    private let apiMethod: String = .TNF_API_NEWS_CONTENT_METHOD
    private let apiIdParam: String = .TNF_API_NEWS_CONTENT_PARAM_ID
    private let apiFetchTo: String = .TNF_API_NEWS_LIST_FETCH_PARAM_LAST
    private let apiRequestMethod: HTTPMethod = .TNF_API_NEWS_CONTENT_REQUEST_METHOD
    private let urlFmt: String = .TNF_API_NEWS_REQUEST_URL_FMT
    private let queryFmt: String = .TNF_API_NEWS_LIST_REQUEST_QUERY_FMT
}
