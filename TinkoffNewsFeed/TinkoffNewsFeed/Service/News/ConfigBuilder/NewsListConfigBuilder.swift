//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

final class NewsListConfigBuilder: INewsListConfigBuilder {

    func build(offset: Int, count: Int) -> RequestConfig<NewsListAPIModel, JSON> {
        let request = buildRequest(offset, count)
        let parser = buildParser()

        return RequestConfig(request: request, parser: parser)
    }

    // MARK: - Private

    private func buildRequest(_ offset: Int, _ count: Int) -> URLRequest {
        let fetchCount = normalizeFetchCount(offset, count)
        let url = String(format: urlFmt, apiHost, apiVersion, apiMethod)
        let query = String(format: queryFmt, apiFetchFrom, offset, apiFetchTo, fetchCount)
        let endpoint = url + query

        let request = try! URLRequest(url: endpoint, method: apiRequestMethod)

        return request
    }

    private func buildParser() -> NewsListParser {
        let parser = NewsListParser()

        return parser
    }

    private func normalizeFetchCount(_ offset: Int, _ count: Int) -> Int {
        // count must be greater than offset
        let count = offset < count ? count : count + offset

        return count
    }

    // MARK: - Constants

    private let apiHost: String = .TNF_API_HOST
    private let apiVersion: String = .TNF_API_NEWS_VERSION
    private let apiMethod: String = .TNF_API_NEWS_LIST_METHOD
    private let apiFetchFrom: String = .TNF_API_NEWS_LIST_FETCH_PARAM_FIRST
    private let apiFetchTo: String = .TNF_API_NEWS_LIST_FETCH_PARAM_LAST
    private let apiRequestMethod: HTTPMethod = .TNF_API_NEWS_LIST_REQUEST_METHOD
    private let urlFmt: String = .TNF_API_NEWS_REQUEST_URL_FMT
    private let queryFmt: String = .TNF_API_NEWS_LIST_REQUEST_QUERY_FMT
}
