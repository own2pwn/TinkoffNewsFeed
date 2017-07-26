//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

final class NewsListProviderAssembler: INewsListProviderAssembler {
    class func assembly() -> INewsListProvider {
        let d = buildDependencies()
        let provider = NewsListProvider(dependencies: d)
        
        return provider
    }
    
    // MARK: - Private
    
    private static func buildDependencies() -> NewsListProviderDependencies {
        let d = NewsListProviderDependencies(requestSender: requestSender,
                                             cacheManager: cacheManager,
                                             coreDataWorker: coreDataWorker,
                                             contextManager: contextManager,
                                             configBuilder: requestConfigBuilder)
        
        return d
    }
    
    private static var cacheManager: INewsListCacheManager {
        return NewsListCacheManagerAssembler.assembly()
    }
    
    private static var coreDataWorker: ICoreDataWorker {
        return CoreDataWorkerAssembler.assembly()
    }
    
    private static var contextManager: ICDContextManager {
        return CDStackAssembler.assembly()
    }
    
    private static var requestSender: IRequestSender {
        return RequestSenderAssembler.assembly()
    }
    
    private static var requestConfigBuilder: INewsListConfigBuilder {
        return NewsListConfigBuilderAssembler.assembly()
    }
}
