//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

final class NewsListCacheManager: INewsListCacheManager {
//    func updateCache(for news: [NewsEntityModel]) {
//        var newsIds = [String]()
//        var newsHashes = [String]()
//        
//        for single in news {
//            let id = single.id
//            let hash = single.titleHash
//            
//            newsIds.append(id)
//            newsHashes.append(hash)
//        }
//        
//        let fmt = "id IN %@ AND (NOT (titleHash in %@))"
//        let predicate = NSPredicate(format: fmt, newsIds, newsHashes)
//        
//        if let toUpdate = coreDataWorker.get(type: News.self, predicate: predicate, sortDescriptors: nil, fetchLimit: nil) {
//            for oldNews in toUpdate {
//                var updatedNews = oldNews
//                let newNews = news.first(where: { $0.id == oldNews.id! })
//                objectMapper.map(newNews!, &updatedNews)
//            }
//            contextManager.performSave(context: saveContext) { error in
//                if let e = error {
//                    log.error(e)
//                }
//            }
//        }
//    }
    
    func cache(_ data: NewsListAPIModel) {
        let news = data.payload!
        
        for single in news {
            var mObject = News(context: saveContext)
            objectMapper.map(single, &mObject)
            mObject.titleHash = single.title.sha1()
            mObject.viewsCount = 0
        }
        contextManager.performSave(context: saveContext) { error in
            if let e = error {
                log.error(e)
            }
        }
    }
    
    // MARK: - DI
    
    init(contextManager: ICDContextManager, objectMapper: IStructToEntityMapper.Type, coreDataWorker: ICoreDataWorker) {
        self.contextManager = contextManager
        saveContext = contextManager.saveContext
        
        self.objectMapper = objectMapper
        self.coreDataWorker = coreDataWorker
    }
    
    private let contextManager: ICDContextManager
    private let saveContext: NSManagedObjectContext
    private let objectMapper: IStructToEntityMapper.Type
    private let coreDataWorker: ICoreDataWorker
}
