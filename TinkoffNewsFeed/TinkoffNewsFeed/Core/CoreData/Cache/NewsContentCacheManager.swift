//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

final class NewsContentCacheManager {
    func cache(_ id: String, _ data: NewsContentPayload) {
        
        // TODO: use threads
        
        // search for existing news
        if let news = coreDataWorker.findFirst(by: "id", value: id, entity: News.self) {
            
            // if there is then check to update its content
            if let content = news.content {
                // Updating existing cache
                if data.modifiedAt > content.modifiedAt! as Date {
                    content.content = data.content
                    content.modifiedAt = data.modifiedAt as NSDate
                    contextManager.performSave(context: saveContext)

                    log.debug("Updating existing cache")
                    return
                }
            } else {
                // no content - should add
                var newsContent = NewsContent(context: saveContext)
                objectMapper.map(data, &newsContent)
                news.content = newsContent
                contextManager.performSave(context: saveContext)
            }
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
