//
// Created by Evgeniy on 25.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct ContentDisplayModel {
    let success: Bool
    let content: String
}

final class NewsContentProvider: INewsContentProvider {
    func load(by id: String, completion: @escaping (ContentDisplayModel) -> Void) {
        let config = buildRequestConfig(id)
        let sender = requestSender()
        
        sender.sendJSON(config: config) { [unowned self] (response) in
            self.cache(response, completion: completion)
        }
    }

    // MARK: - Private

    // TODO: user protocol based generic
    // buildConfig<T> -> T ...
    
    private func buildRequestConfig(_ id: String) -> RequestConfig<NewsContentAPIModel, JSON> {
        let request = buildRequest(id)
        let parser = contentParser()
        
        let config: RequestConfig<NewsContentAPIModel, JSON> = RequestConfig(request: request, parser: parser)
        
        return config
    }
    
    private func cache(_ response: IResult<NewsContentAPIModel>,
                       completion: (ContentDisplayModel) -> Void) {
        switch response {
        case .error(let e):
            log.error(e)
            let model = ContentDisplayModel(success: false, content: e)
            completion(model)
        case .success(let content):
            let payload = content.payload
            let model = ContentDisplayModel(success: true, content: payload!.content)
            completion(model)
            // cacheManager.cache(result)
        }
    }
    
    // TODO: use protocol based parsers
    // extract it
    
    private func requestSender() -> IRequestSender {
        let sender = RequestSender()
        
        return sender
    }
    
    private func contentParser() -> NewsContentParser {
        let parser = NewsContentParser()
        
        return parser
    }

    private func buildRequest(_ id: String) -> URLRequest {
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
    private let apiRequestMethod: HTTPMethod = .TNF_API_NEWS_CONTENT_REQUEST_METHOD
    private let urlFmt: String = .TNF_API_NEWS_REQUEST_URL_FMT
    private let queryFmt: String = .TNF_API_NEWS_CONTENT_REQUEST_QUERY_FMT
}
