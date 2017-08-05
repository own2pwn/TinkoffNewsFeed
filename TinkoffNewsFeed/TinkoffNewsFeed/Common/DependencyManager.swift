//
//  DependencyManager.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 26.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import CoreData
import SwinjectStoryboard

extension SwinjectStoryboard {
    public static func setup() {
        
        // MARK: - NewsListViewController
        
        defaultContainer.storyboardInitCompleted(NewsListViewController.self) { r, c in
            c.model = r.resolve(INewsListModel.self, argument: c)!
        }
        
        // MARK: INewsListModel
        
        defaultContainer.register(INewsListModel.self) { (r, view: NewsListViewController) in
            let nlProvider = r.resolve(INewsListProvider.self)!
            let frc = r.resolve(NSFetchedResultsController<News>.self, argument: view)!
            let syncer = r.resolve(IManagedObjectSynchronizer.self)!
            
            let d = NewsListModelDependencies(newsProvider: nlProvider,
                                              frc: frc,
                                              syncer: syncer)
            
            return NewsListModel(view: view, dependencies: d)
        }
        
        // MARK: - NewsContentViewController
        
        defaultContainer.storyboardInitCompleted(NewsContentViewController.self) { r, c in
            c.model = r.resolve(INewsContentModel.self)!
        }
        
        // MARK: INewsContentModel
        
        defaultContainer.register(INewsContentModel.self) { r in
            let ncProvider = r.resolve(INewsContentProvider.self)!
            return NewsContentModel(contentProvider: ncProvider)
        }
        
        // MARK: - Service
        
        defaultContainer.register(INewsListConfigBuilder.self) { _ in NewsListConfigBuilder() }
        
        defaultContainer.register(INewsContentConfigBuilder.self) { _ in NewsContentConfigBuilder() }
        
        defaultContainer.register(INewsListProvider.self) { r in
            let rs = r.resolve(IRequestSender.self)!
            let cm = r.resolve(INewsListCacheManager.self)!
            let cdWorker = r.resolve(ICoreDataWorker.self)!
            let cfgBuilder = r.resolve(INewsListConfigBuilder.self)!
            
            let d = NewsListProviderDependencies(requestSender: rs,
                                                 cacheManager: cm,
                                                 coreDataWorker: cdWorker,
                                                 configBuilder: cfgBuilder)
            
            return NewsListProvider(dependencies: d)
        }
        
        defaultContainer.register(INewsContentProvider.self) { r in
            let cm = r.resolve(INewsContentCacheManager.self)!
            let rs = r.resolve(IRequestSender.self)!
            let cfgBuilder = r.resolve(INewsContentConfigBuilder.self)!
            
            let d = NewsContentProviderDependencies(cacheManager: cm,
                                                    requstSender: rs,
                                                    configBuilder: cfgBuilder)
            return NewsContentProvider(dependencies: d)
        }
        
        // MARK: - Core
        
        // MARK: Cache
        
        defaultContainer.register(INewsListCacheManager.self) { r in
            let ctxManager = r.resolve(ICDContextManager.self)!
            let mapper = r.resolve(IStructToEntityMapper.Type.self)!
            let cdWorker = r.resolve(ICoreDataWorker.self)!
            
            return NewsListCacheManager(contextManager: ctxManager,
                                        saveContext: ctxManager.saveContext,
                                        objectMapper: mapper,
                                        coreDataWorker: cdWorker)
        }
        
        defaultContainer.register(INewsContentCacheManager.self) { r in
            let ctxManager = r.resolve(ICDContextManager.self)!
            let cdWorker = r.resolve(ICoreDataWorker.self)!
            let mapper = r.resolve(IStructToEntityMapper.Type.self)!
            
            return NewsContentCacheManager(contextManager: ctxManager,
                                           saveContext: ctxManager.saveContext,
                                           coreDataWorker: cdWorker,
                                           objectMapper: mapper)
        }
        
        // MARK: Fetch stuff
        
        defaultContainer.register(NSFetchRequest<News>.self) { r in
            let frProvider = r.resolve(IFetchRequestProvider.Type.self)!
            
            let sortKey = #keyPath(News.pubDate)
            let pubDateSorter = NSSortDescriptor(key: sortKey, ascending: false)
            let newsBatchSize: Int = .TNF_API_REQUEST_NEWS_BATCH_SIZE
            
            let fr = frProvider.fetchRequest(object: News.self, sortDescriptors: [pubDateSorter], predicate: nil, fetchLimit: newsBatchSize)
            fr.fetchBatchSize = 2 * newsBatchSize
            
            return fr
        }
        
        defaultContainer.register(NSFetchedResultsController<News>.self) { (r, delegate: NewsListViewController) in
            let fr = r.resolve(NSFetchRequest<News>.self)!
            let ctxManager = r.resolve(ICDContextManager.self)!
            
            let frc = NSFetchedResultsController(fetchRequest: fr,
                                                 managedObjectContext: ctxManager.mainContext,
                                                 sectionNameKeyPath: nil,
                                                 cacheName: nil)
            
            frc.delegate = delegate
            
            return frc
        }
        
        defaultContainer.register(IFetchedResultsControllerManager.self) { r in
            let ctxManager = r.resolve(ICDContextManager.self)!
            return FetchedResultsControllerManager(uiContext: ctxManager.mainContext)
        }
        
        defaultContainer.register(IFetchRequestProvider.Type.self) { _ in FetchRequestProvider.self }
        
        // MARK: CoreData
        
        defaultContainer.register(IManagedObjectSynchronizer.self) { r in
            let ctxManager = r.resolve(ICDContextManager.self)!
            return ManagedObjectSynchronizer(contextManager: ctxManager)
        }
        
        defaultContainer.register(ICoreDataWorker.self) { r in
            let ctxManager = r.resolve(ICDContextManager.self)!
            let saveContext = ctxManager.saveContext
            
            return CoreDataWorker(context: saveContext)
        }
        
        defaultContainer.register(ICDContextManager.self) { r in r.resolve(ICDStack.self)! }
        
        defaultContainer.register(ICDStack.self) { _ in CDStack() }.inObjectScope(.container)
        
        // MARK: Network
        
        defaultContainer.register(IRequestSender.self) { _ in RequestSender() }.inObjectScope(.container)
        
        // MARK: - Other
        
        defaultContainer.register(IStructToEntityMapper.Type.self) { _ in StructToEntityMapper.self }
    }
}
