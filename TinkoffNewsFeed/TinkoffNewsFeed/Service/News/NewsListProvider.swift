//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct NewsListProviderDependencies {
    let requestSender: IRequestSender
    let cacheManager: INewsListCacheManager
    let coreDataWorker: ICoreDataWorker
    let contextManager: ICDContextManager
    let configBuilder: INewsListConfigBuilder
}

final class NewsListProvider: INewsListProvider {
    
    func loadNew(completion: (() -> Void)?) {
        // get last saved news
        // while we've got this news, load with updated offset again
    }
    
    func update(offset: Int = 0, count: Int, completion: ((String?) -> Void)? = nil) {
        let config = configBuilder.build(offset: offset, count: count)
        
        requestSender.sendJSON(config: config) { [unowned self] result in
            switch result {
            case .error(let e):
                completion?(e)
            case .success(let data):
                if let payload = data.payload {
                    let newsCount = payload.count
                    if newsCount > 0 {
                        self.cacheManager.cache(payload)
                        let newOffset = offset + count
                        self.update(offset: newOffset, count: count, completion: completion)
                    } else {
                        completion?(nil)
                    }
                } else {
                    log.warning("no payload provided")
                    completion?("no payload provided")
                }
            }
        }
    }
    
    func loadCached(completion: ([News]?) -> Void) {
        let sortDescriptor = [NSSortDescriptor(key: "pubDate", ascending: false)]
        let news = coreDataWorker.get(type: News.self,
                                      predicate: nil,
                                      sortDescriptors: sortDescriptor,
                                      fetchLimit: nil)
        log.debug("Retrieved news count: \(news?.count)")
        completion(news)
    }
    
    func load(offset: Int = 0, count: Int, completion: (() -> Void)? = nil) {
        let config = configBuilder.build(offset: offset, count: count)
        
        requestSender.sendJSON(config: config) { [unowned self] result in
            completion?()
            self.verify(result)
            // TODO: maybe compelte with error if gained no data from api
            // TODO: check if it save here to use unowned
            // or not to
        }
    }
    
    // MARK: - Private
    
    private func verify(_ response: IResult<NewsListAPIModel>) {
        switch response {
        case .error(let e):
            log.error(e)
        case .success(let result):
            cacheManager.cache(result)
            break
        }
    }
    
    // MARK: - DI
    
    init(dependencies: NewsListProviderDependencies) {
        cacheManager = dependencies.cacheManager
        requestSender = dependencies.requestSender
        coreDataWorker = dependencies.coreDataWorker
        contextManager = dependencies.contextManager
        configBuilder = dependencies.configBuilder
    }
    
    private let requestSender: IRequestSender
    private let cacheManager: INewsListCacheManager
    private let coreDataWorker: ICoreDataWorker
    private let contextManager: ICDContextManager
    private let configBuilder: INewsListConfigBuilder
}
