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

        // TODO: make an ext
        let name = String(describing: T.self)
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
    
    func save(_ context: NSManagedObjectContext) {
        
    }

    // MARK: - DI

    init(contextManager: ICDContextManager) {
        self.contextManager = contextManager
        context = contextManager.saveContext
    }

    private let contextManager: ICDContextManager
    private let context: NSManagedObjectContext
}

final class NewsContentCacheManager {
    func cache(_ id: String, _ data: NewsContentPayload) {
        if let news = coreDataWorker.findFirst(by: "id", value: id, entity: News.self) {
            var newsContent = NewsContent(context: saveContext)
            objectMapper.map(data, &newsContent)
            newsContent.news = news
            co
            //            newsContent.content = data.content
            //            newsContent.createdAt = data.createdAt as NSDate
            //            newsContent.modifiedAt = data.createdAt as NSDate
        } else {
            log.error("Couldn't find new entity!")
        }
    }

    // MARK: - Private
    // TODO: user CDWorker

    // MARK: - DI

    init(contextManager: ICDContextManager, coreDataWorker: ICoreDataWorker,
         objectMapper: IStructToEntityMapper.Type) {
        self.contextManager = contextManager
        saveContext = contextManager.saveContext

        self.coreDataWorker = coreDataWorker
        self.objectMapper = objectMapper
    }

    private let contextManager: ICDContextManager
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
