//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

protocol ICoreDataWorker {
    func find<T:NSManagedObject>(by attribute: String, value: String, entity: T.Type) -> [T]?

    func findFirst<T:NSManagedObject>(by attribute: String, value: String, entity: T.Type) -> T?
}

final class CoreDataWorker: ICoreDataWorker {
    func find<T:NSManagedObject>(by attribute: String, value: String, entity: T.Type) -> [T]? {
        let name = T.entityName
        let fr = NSFetchRequest<T>(entityName: name)
        let predicate = NSPredicate(format: "%K == %@", attribute, value)
        fr.predicate = predicate

        let result = try? context.fetch(fr)

        return result
    }

    func findFirst<T:NSManagedObject>(by attribute: String, value: String, entity: T.Type) -> T? {
        let result = find(by: attribute, value: value, entity: entity)

        return result?.first
    }

    // MARK: - DI

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    private let context: NSManagedObjectContext
}

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
                //TODO: do check in another place!
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
    //TODO: pass context in construct, rename member to context
    private let saveContext: NSManagedObjectContext
    private let coreDataWorker: ICoreDataWorker
    private let objectMapper: IStructToEntityMapper.Type
}


/**

 let name = String(describing: News.self)
        let fr = NSFetchRequest<News>(entityName: name)

        let dateSorter = NSSortDescriptor(key: "pubDate", ascending: false)
        let sortDescriptors = [dateSorter]
        fr.sortDescriptors = sortDescriptors
        fr.fetchBatchSize = 20
        fr.fetchLimit = 20
        // fr.fetchOffset = 5

        let frc = NSFetchedResultsController(fetchRequest: fr,
                managedObjectContext: stack.mainContext,
                sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        // TODO: perform fetch only when needed
        try! frc.performFetch()
        fetchedNewsCount = frc.sections![0].numberOfObjects

*/
