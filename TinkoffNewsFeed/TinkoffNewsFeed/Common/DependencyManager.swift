//
//  DependencyManager.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 26.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

typealias NewsListModelViewConstraint = (NSFetchedResultsControllerDelegate & NewsListViewDelegate)

final class DependencyManager {
    
    static func newsListModel(for view: NewsListModelViewConstraint) -> INewsListModel {
        let model = NewsListModel(view: view, dependencies: newsListModelDependencies)
        
        return model
        
    }
    
    static func newsContenModel() -> INewsContentModel {
        let model = NewsContentModel(contentProvider: newsContentProvider)
        
        return model
    }
    
    // MARK: - Private
    
    private static var newsContentProvider: INewsContentProvider {
        let provider = NewsContentProvider()
        
        return provider
    }
    
    private static var newsListProvider: INewsListProvider {
        let provider = NewsListProvider(dependencies: newsListProviderDependencies)
        
        return provider
    }
    
    // MARK: - Dependencies
    
    private static var newsListModelDependencies: NewsListModelDependencies {
        let d = NewsListModelDependencies(newsProvider: newsListProvider,
                                          fetchRequestProvider: fetchRequestProvider,
                                          frcManager: fetchedResultsControllerManager,
                                          syncer: managedObjectSynchronizer)
        
        return d
    }
    
    private static var newsListProviderDependencies: NewsListProviderDependencies {
        let d = NewsListProviderDependencies(requestSender: requestSender,
                                             cacheManager: newsListCacheManager,
                                             coreDataWorker: coreDataWorker,
                                             contextManager: contextManager,
                                             configBuilder: newsListConfigBuilder)
        
        return d
    }
    
    // MARK: -
    
    // MARK: - CoreData
    
    private static var managedObjectSynchronizer: IManagedObjectSynchronizer {
        let syncer = ManagedObjectSynchronizer(contextManager: contextManager)
        
        return syncer
    }
    
    private static var fetchedResultsControllerManager:IFetchedResultsControllerManager {
        let manager = FetchedResultsControllerManager(context: masterContext)
        
        return manager
    }
    
    private static var newsListCacheManager: INewsListCacheManager {
        let manager = NewsListCacheManager(contextManager: contextManager,
                                           objectMapper: objectMapper,
                                           coreDataWorker: coreDataWorker)
        
        return manager
    }
    
    
    private static var coreDataWorker: ICoreDataWorker {
        let worker = CoreDataWorker(context: saveContext)
        
        return worker
    }
    
    private static var masterContext: NSManagedObjectContext {
        return contextManager.masterContext
    }
    
    private static var saveContext: NSManagedObjectContext {
        return contextManager.saveContext
    }
    
    private static var contextManager: ICDContextManager {
        return stackAssembler
    }
    
    private static var stackAssembler: ICDStack {
        return CDStack()
    }
    
    // MARK: - Network
    
    private static var newsListConfigBuilder: INewsListConfigBuilder {
        let builder = NewsListConfigBuilder()
        
        return builder
    }
    
    private static var requestSender: IRequestSender {
        return RequestSender()
    }
    
    // MARK: - Static
    
    private static var fetchRequestProvider: IFetchRequestProvider.Type {
        return FetchRequestProvider.self
    }
    
    private static var objectMapper: IStructToEntityMapper.Type {
        let mapper = StructToEntityMapper.self
        
        return mapper
    }
}
