//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

// TODO: move to core layer


final class NewsListCacheManager: INewsListCacheManager {
    func cache(_ news: NewsEntityModel...) {
        for single in news {
            let mObject = News(context: saveContext)

        }
    }

    private func mapModelToObject(_ model: NewsEntityModel) {
        let mObject = News(context: saveContext)
        objectMapper.map(model, &mObject)
        try? contextManager.performSave(context: saveContext) { error in
            if let e = error {
                log.error(e)
            }
        }
    }

    // TODO: extract to assembler

    init(contextManager: ICDContextManager,
         objectMapper: IStructToEntityMapper.Type) {
        self.contextManager = contextManager
        saveContext = contextManager.saveContext

        self.objectMapper = objectMapper
    }

    private let contextManager: ICDContextManager
    private let saveContext: NSManagedObjectContext
    private let objectMapper: IStructToEntityMapper.Type
}
