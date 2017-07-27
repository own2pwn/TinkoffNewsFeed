//
// Created by Evgeniy on 25.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct NewsContentProviderDependencies {
    let contextManager: ICDContextManager
    let coreDataWorker: ICoreDataWorker
    let objectMapper: IStructToEntityMapper.Type
    let cacheManager: INewsContentCacheManager
    let requstSender: IRequestSender
    let configBuilder: INewsContentConfigBuilder
}

final class NewsContentProvider: INewsContentProvider {
    func load(by id: String, completion: @escaping (NewsContentDisplayModel) -> Void) {
        let config = configBuilder.build(id)

        requstSender.sendJSON(config: config) { [unowned self] response in
            self.cache(id, response, completion: completion)
        }
    }

    // MARK: - Private

    // TODO: user protocol based generic
    // buildConfig<T> -> T ...

    private func cache(_ id: String, _ response: IResult<NewsContentAPIModel>,
                       completion: (NewsContentDisplayModel) -> Void) {
        switch response {
        case .error(let e):
            log.error(e)
            let model = NewsContentDisplayModel(error: true, content: e)
            completion(model)
        case .success(let content):
            let payload = content.payload!
            let model = NewsContentDisplayModel(error: false, content: payload.content)
            completion(model)
            cacheManager.cache(id, payload)
        }
    }

    // MARK: - DI

    init(dependencies: NewsContentProviderDependencies) {
        contextManager = dependencies.contextManager
        coreDataWorker = dependencies.coreDataWorker
        objectMapper = dependencies.objectMapper
        cacheManager = dependencies.cacheManager
        requstSender = dependencies.requstSender
        configBuilder = dependencies.configBuilder
    }

    private let contextManager: ICDContextManager
    private let coreDataWorker: ICoreDataWorker
    private let objectMapper: IStructToEntityMapper.Type
    private let cacheManager: INewsContentCacheManager
    private let requstSender: IRequestSender
    private let configBuilder: INewsContentConfigBuilder
}
