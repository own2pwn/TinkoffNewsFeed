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
    let configBuilder: INewsListConfigBuilder
}

final class NewsListProvider: INewsListProvider {
    
    // MARK: - INewsListProvider
    
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
                }
            }
        }
    }
    
    func load(offset: Int = 0, count: Int, completion: ((String?) -> Void)? = nil) {
        let config = configBuilder.build(offset: offset, count: count)
        
        requestSender.sendJSON(config: config) { [unowned self] result in
            switch result {
            case .error(let e):
                completion?(e)
            case .success(let data):
                if let payload = data.payload {
                    self.cacheManager.cache(payload)
                    completion?(nil)
                }
            }
        }
    }
    
    func loadCached(offset: Int, completion: @escaping ([News]?) -> Void) {
        queue.sync { [unowned self] in
            let sortDescriptor = [NSSortDescriptor(key: "pubDate", ascending: false)]
            let news = self.coreDataWorker.get(type: News.self,
                                               predicate: nil,
                                               sortDescriptors: sortDescriptor,
                                               offset: offset,
                                               fetchLimit: self.newsBatchSize)
            completion(news)
        }
    }
    
    // MARK: - Private
    
    // MARK: - DI
    
    init(dependencies: NewsListProviderDependencies) {
        cacheManager = dependencies.cacheManager
        requestSender = dependencies.requestSender
        coreDataWorker = dependencies.coreDataWorker
        configBuilder = dependencies.configBuilder
    }
    
    private let requestSender: IRequestSender
    private let cacheManager: INewsListCacheManager
    private let coreDataWorker: ICoreDataWorker
    private let configBuilder: INewsListConfigBuilder
    
    private let queue = DispatchQueue(label: "tnf.service")
    private let newsBatchSize: Int = .TNF_API_REQUEST_NEWS_BATCH_SIZE
}
