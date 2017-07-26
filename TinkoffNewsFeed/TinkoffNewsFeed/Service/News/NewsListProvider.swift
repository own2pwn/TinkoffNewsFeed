//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

private struct NewsListAPIResponse {
    let statusCode: String
    //let payload:
}

struct NewsListAPIModel {
    let newsId: String
    let title: String
    let publicationDate: String
}

// TODO: rename to `NewsListAPIModel`
// or something else

struct NewsEntityModel: IEntityMappable {
    var id: String
    var pubDate: Date
    var title: String
    var titleHash: String
    let viewsCount = 0
}

final class NewsListProvider: INewsListProvider {

    func loadNew(completion: (() -> Void)?) {
        // get last saved news
        // while we've got this news, load with updated offset again


    }

    func loadSaved(completion: ([News]?) -> Void) {
        let news = coreDataWorker.
    }
    
    // TODO: DI
    
    private func initContextManager() -> ICDContextManager {
        let manager = CDStack()
        contextManager = manager
        
        return manager
    }
    
    private func initCoreDataWorker() -> ICoreDataWorker{
        let worker = CoreDataWorker(context: contextManager.saveContext)
        coreDataWorker = worker
        
        return worker
    }
    
    private var coreDataWorker: ICoreDataWorker!
    private var contextManager: ICDContextManager!

    func load(offset: Int = 0, count: Int,
              completion: (() -> Void)? = nil) {
        // offset always have to be lower than count
        let count = offset < count ? count : count + offset

        let config = buildRequestConfig(offset: offset, count: count)
        requestSender.sendJSON(config: config) { [unowned self] (result) in
            self.cache(result)
            // TODO: check if it save here to use unowned
            // or not to
        }
    }

    private func cache(_ response: IResult<[NewsEntityModel]>) {
        switch response {
        case .error(let e):
            log.error(e)
        case .success(let result):
            cacheManager.cache(result)
        }
    }

    // TODO: load config as dependency

    private func buildRequestConfig(offset: Int, count: Int) ->
            RequestConfig<[NewsEntityModel], JSON> {
        let request = buildRequest(offset, count)
        let parser = newsListParser()

        let config: RequestConfig<[NewsEntityModel], JSON> =
                RequestConfig(request: request, parser: parser)

        return config
    }

    private func newsListParser() -> NewsListParser {
        let parser = NewsListParser()

        return parser
    }

    // TODO: extract to request builder
    // TODO: or make a r. config builder

    private func buildRequest(_ offset: Int, _ count: Int) -> URLRequest {
        let url = String(format: urlFmt, apiHost, apiVersion, apiMethod)
        let query = String(format: queryFmt, apiFetchFrom, offset, apiFetchTo, count)
        let endpoint = url + query

        let request = try! URLRequest(url: endpoint, method: apiRequestMethod)

        return request
    }

    // MARK: - DI

    init(cacheManager: INewsListCacheManager, requestSender: IRequestSender) {
        self.cacheManager = cacheManager
        self.requestSender = requestSender
        
        _ = initContextManager()
        _ = initCoreDataWorker()
    }

    private let requestSender: IRequestSender
    private let cacheManager: INewsListCacheManager

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
