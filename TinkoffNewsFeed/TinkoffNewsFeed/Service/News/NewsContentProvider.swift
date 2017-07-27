//
// Created by Evgeniy on 25.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct NewsContentProviderDependencies {
    let cacheManager: INewsContentCacheManager
    let requstSender: IRequestSender
    let configBuilder: INewsContentConfigBuilder
}

final class NewsContentProvider: INewsContentProvider {
    func load(by id: String, completion: @escaping (NewsContentDisplayModel) -> Void) {
        let config = configBuilder.build(id)
        
        requstSender.sendJSON(config: config) { [weak self] result in
            switch result {
            case .error(let e):
                log.warning(e)
                let model = NewsContentDisplayModel(error: true, content: e)
                completion(model)
            case .success(let data):
                let payload = data.payload!
                self?.cacheManager.cache(id, payload)
                let model = NewsContentDisplayModel(error: false, content: payload.content)
                completion(model)
            }
        }
    }
    
    // MARK: - DI
    
    init(dependencies: NewsContentProviderDependencies) {
        cacheManager = dependencies.cacheManager
        requstSender = dependencies.requstSender
        configBuilder = dependencies.configBuilder
    }
    
    private let cacheManager: INewsContentCacheManager
    private let requstSender: IRequestSender
    private let configBuilder: INewsContentConfigBuilder
}
