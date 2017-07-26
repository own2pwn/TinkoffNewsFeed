//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

final class NewsListCacheManagerAssembler: INewsListCacheManagerAssembler {
    class func assembly() -> INewsListCacheManager {
        let manager = NewsListCacheManager(contextManager: contextManager, objectMapper: objectMapper, coreDataWorker: coreDataWorker)

        return manager
    }

    // MARK: - Private

    private static var objectMapper: IStructToEntityMapper.Type {
        return StructToEntityMapperAssembler.assembly()
    }

    private static var coreDataWorker: ICoreDataWorker {
        return CoreDataWorkerAssembler.assembly()
    }

    private static var contextManager: ICDContextManager {
        return CDStackAssembler.assembly()
    }
}
