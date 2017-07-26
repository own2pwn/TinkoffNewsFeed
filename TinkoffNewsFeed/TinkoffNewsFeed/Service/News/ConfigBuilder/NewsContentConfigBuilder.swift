//
//  NewsContentConfigBuilder.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 26.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

final class NewsContentConfigBuilder: INewsContentConfigBuilder {
    func build(_ id: String) -> RequestConfig<NewsContentAPIModel, JSON> {
        let request = buildRequest(id)
        let parser = buildParser()
        
        return RequestConfig(request: request, parser: parser)
    }
    
    // MARK: - Private
    
    private func buildRequest(_ id: String) -> URLRequest {
        let url = String(format: urlFmt, apiHost, apiVersion, apiMethod)
        let query = String(format: queryFmt, apiIdParam, id)
        let endpoint = url + query
        
        let request = try! URLRequest(url: endpoint, method: apiRequestMethod)
        
        return request
    }
    
    private func buildParser() -> NewsContentParser {
        let parser = NewsContentParser()
        
        return parser
    }
    
    // MARK: - Constants
    
    private let apiHost: String = .TNF_API_HOST
    private let apiVersion: String = .TNF_API_NEWS_VERSION
    private let apiMethod: String = .TNF_API_NEWS_CONTENT_METHOD
    private let apiIdParam: String = .TNF_API_NEWS_CONTENT_PARAM_ID
    private let apiRequestMethod: HTTPMethod = .TNF_API_NEWS_CONTENT_REQUEST_METHOD
    private let urlFmt: String = .TNF_API_NEWS_REQUEST_URL_FMT
    private let queryFmt: String = .TNF_API_NEWS_CONTENT_REQUEST_QUERY_FMT
}
