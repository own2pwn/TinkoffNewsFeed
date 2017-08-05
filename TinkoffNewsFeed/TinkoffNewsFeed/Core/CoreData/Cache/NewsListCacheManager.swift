//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData
import CryptoSwift

final class NewsListCacheManager: INewsListCacheManager {
    
    // MARK: - INewsListCacheManager
    
    func cache(_ payload: [NewsListPayload]) {
        queue.sync { [weak self] in
            if let strongSelf = self {
                strongSelf.updateCache(for: payload)
                
                let existingNewsIds = strongSelf.getExistingNewsIds()
                let newsIds = strongSelf.getNewsIds(payload)
                let newNewsIds = newsIds.subtracting(existingNewsIds)
                
                for news in payload where newNewsIds.contains(news.id) {
                    var mObject = News(context: strongSelf.saveContext)
                    strongSelf.objectMapper.map(news, &mObject)
                    mObject.viewsCount = 0
                    mObject.titleHash = news.title.sha1()
                    mObject.title = mObject.title?.decodeHTML()
                }
                
                strongSelf.contextManager.performSave(context: strongSelf.saveContext) { error in
                    if let e = error {
                        log.error(e)
                    }
                }
            }
        }
    }
    
    // MARK: - Private
    
    private func updateCache(for news: [NewsListPayload]) {
        var newsIds = Set<String>()
        var newsHashes = Set<String>()
        
        for single in news {
            let id = single.id
            let hash = single.title.sha1()
            
            newsIds.insert(id)
            newsHashes.insert(hash)
        }
        
        // if title hash has been changed we have to update title itself
        let fmt = "id IN %@ AND (NOT (titleHash in %@))"
        let predicate = NSPredicate(format: fmt, newsIds, newsHashes)
        
        if let toUpdate = coreDataWorker.get(type: News.self, predicate: predicate) {
            for oldNews in toUpdate {
                var updatedNews = oldNews
                let newNews = news.first(where: { $0.id == oldNews.id! })!
                objectMapper.map(newNews, &updatedNews)
                updatedNews.titleHash = newNews.title.sha1()
            }
        }
    }
    
    private func getNewsIds(_ news: [NewsListPayload]) -> Set<String> {
        var ids = Set<String>()
        
        for single in news {
            let id = single.id
            ids.insert(id)
        }
        
        return ids
    }
    
    private func getExistingNewsIds() -> Set<String> {
        var ids = Set<String>()
        
        let properties = ["id"]
        if let existingNews = self.coreDataWorker.getDict(type: News.self, predicate: nil, propertiesToFetch: properties) {
            for news in existingNews {
                let newsInfo = news as! [String: String]
                let id = newsInfo["id"]!
                ids.insert(id)
            }
        }
        
        return ids
    }
    
    // MARK: - DI
    
    init(contextManager: ICDContextManager, saveContext: NSManagedObjectContext,
         objectMapper: IStructToEntityMapper.Type, coreDataWorker: ICoreDataWorker) {
        self.contextManager = contextManager
        self.saveContext = saveContext
        self.objectMapper = objectMapper
        self.coreDataWorker = coreDataWorker
    }
    
    private let contextManager: ICDContextManager
    private let saveContext: NSManagedObjectContext
    private let objectMapper: IStructToEntityMapper.Type
    private let coreDataWorker: ICoreDataWorker
    
    private let queue: DispatchQueue = DispatchQueue(label: "tnf.newscache")
}
