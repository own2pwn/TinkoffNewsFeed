//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

final class NewsContentCacheManager {
    func cache(_ id: String, _ data: NewsContentPayload) {
        if let news = coreDataWorker.findFirst(by: "id", value: id, entity: News.self) {
            if let content = news.content {

                // Updating existing cache
                if data.modifiedAt > content.modifiedAt! as Date {
                    content.content = data.content
                    content.modifiedAt = data.modifiedAt as NSDate
                    contextManager.performSave(context: saveContext)

                    log.debug("Updating existing cache")
                    return
                }
                // TODO: do check in another place!
                log.debug("There is existing content")
                log.debug("Skipping caching!")
                return
            }

            var newsContent = NewsContent(context: saveContext)
            objectMapper.map(data, &newsContent)
            newsContent.news = news
            contextManager.performSave(context: saveContext)
        } else {
            log.warning("Couldn't find news entity with id: \(id)!")
        }
    }

    // MARK: - Private

    // MARK: - DI

    init(contextManager: ICDContextManager, coreDataWorker: ICoreDataWorker,
         objectMapper: IStructToEntityMapper.Type) {
        self.contextManager = contextManager
        saveContext = contextManager.saveContext

        self.coreDataWorker = coreDataWorker
        self.objectMapper = objectMapper
    }

    private let contextManager: ICDContextManager
    //TODO: pass context in constructor, rename member to context
    private let saveContext: NSManagedObjectContext
    private let coreDataWorker: ICoreDataWorker
    private let objectMapper: IStructToEntityMapper.Type
}
