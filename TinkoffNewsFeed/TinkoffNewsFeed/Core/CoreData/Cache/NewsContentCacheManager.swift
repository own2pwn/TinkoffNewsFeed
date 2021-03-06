//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

final class NewsContentCacheManager: INewsContentCacheManager {
    func cache(_ id: String, _ data: NewsContentPayload) {
        queue.sync { [weak self] in
            if let strongSelf = self {
                // search for existing news
                if let news = strongSelf.coreDataWorker.findFirst(by: "id", value: id, entity: News.self) {

                    // if any then check to update its content
                    if let content = news.content {
                        if data.modifiedAt > content.modifiedAt! as Date {
                            content.content = data.content
                            content.modifiedAt = data.modifiedAt as NSDate
                            strongSelf.contextManager.performSave(context: strongSelf.saveContext)

                            log.debug("Updating existing cache")
                            return
                        }
                    } else {
                        // no content - should add
                        var newsContent = NewsContent(context: strongSelf.saveContext)
                        strongSelf.objectMapper.map(data, &newsContent)
                        news.content = newsContent
                        strongSelf.contextManager.performSave(context: strongSelf.saveContext)
                    }
                } else {
                    log.warning("Couldn't find news entity with id: \(id)!")
                }
            }
        }
    }

    // MARK: - Private

    // MARK: - DI

    init(contextManager: ICDContextManager, saveContext: NSManagedObjectContext,
         coreDataWorker: ICoreDataWorker,
         objectMapper: IStructToEntityMapper.Type) {
        self.contextManager = contextManager
        self.saveContext = saveContext
        self.coreDataWorker = coreDataWorker
        self.objectMapper = objectMapper
    }

    private let contextManager: ICDContextManager
    private let saveContext: NSManagedObjectContext
    private let coreDataWorker: ICoreDataWorker
    private let objectMapper: IStructToEntityMapper.Type

    private let queue = DispatchQueue(label: "tnf.newscache")
}
