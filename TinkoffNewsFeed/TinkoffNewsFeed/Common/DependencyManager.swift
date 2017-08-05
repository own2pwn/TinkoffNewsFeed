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
        
        // MARK: - INewsListModel
        
        defaultContainer.register(INewsListModel.self) { (r, view: NewsListViewController) in
            let nlProvider = r.resolve(INewsListProvider.self)!
            let frc = r.resolve(NSFetchedResultsController<News>.self, argument: view)!
            let syncer = r.resolve(IManagedObjectSynchronizer.self)!
            
            let d = NewsListModelDependencies(newsProvider: nlProvider,
                                              frc: frc,
                                              syncer: syncer)
            
            return NewsListModel(view: view, dependencies: d)
        }
        
        // MARK: -  NewsContentViewController
        
        defaultContainer.storyboardInitCompleted(NewsContentViewController.self) { r, c in
            c.model = r.resolve(INewsContentModel.self)!
        }
        
        // MARK: - INewsContentModel
        
        defaultContainer.register(INewsContentModel.self) { r in
            let ncProvider = r.resolve(INewsContentProvider.self)!
            return NewsContentModel(contentProvider: ncProvider)
        }
        
        // MARK: - Service
        
        defaultContainer.register(INewsContentProvider.self) { r in
            let cm = r.resolve(INewsContentCacheManager.self)!
            let rs = r.resolve(IRequestSender.self)!
            let cfgBuilder = r.resolve(INewsContentConfigBuilder.self)!
            
            let d = NewsContentProviderDependencies(cacheManager: cm,
                                                    requstSender: rs,
                                                    configBuilder: cfgBuilder)
            return NewsContentProvider(dependencies: d)
        }
        
        defaultContainer.register(INewsContentConfigBuilder.self) { _ in NewsContentConfigBuilder() }
        
        defaultContainer.register(INewsContentCacheManager.self) { r in
            let ctxManager = r.resolve(ICDContextManager.self)!
            let cdWorker = r.resolve(ICoreDataWorker.self)!
            let mapper = r.resolve(IStructToEntityMapper.Type.self)!
            
            return NewsContentCacheManager(contextManager: ctxManager,
                                           saveContext: ctxManager.saveContext,
                                           coreDataWorker: cdWorker,
                                           objectMapper: mapper)
        }
        
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
        
        // MARK: - Core
        
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
        
        defaultContainer.register(IManagedObjectSynchronizer.self) { r in
            let ctxManager = r.resolve(ICDContextManager.self)!
            return ManagedObjectSynchronizer(contextManager: ctxManager)
        }
        
        defaultContainer.register(IFetchedResultsControllerManager.self) { r in
            let ctxManager = r.resolve(ICDContextManager.self)!
            return FetchedResultsControllerManager(uiContext: ctxManager.mainContext)
        }
        
        defaultContainer.register(INewsListConfigBuilder.self) { _ in NewsListConfigBuilder() }
        
        defaultContainer.register(IRequestSender.self) { _ in RequestSender() }.inObjectScope(.container)
        
        defaultContainer.register(INewsListCacheManager.self) { r in
            let ctxManager = r.resolve(ICDContextManager.self)!
            let mapper = r.resolve(IStructToEntityMapper.Type.self)!
            let cdWorker = r.resolve(ICoreDataWorker.self)!
            
            return NewsListCacheManager(contextManager: ctxManager,
                                        saveContext: ctxManager.saveContext,
                                        objectMapper: mapper,
                                        coreDataWorker: cdWorker)
        }
        
        defaultContainer.register(IStructToEntityMapper.Type.self) { _ in StructToEntityMapper.self }
        
        defaultContainer.register(ICDContextManager.self) { r in r.resolve(ICDStack.self)! }
        
        defaultContainer.register(ICoreDataWorker.self) { r in
            let ctxManager = r.resolve(ICDContextManager.self)!
            let saveContext = ctxManager.saveContext
            
            return CoreDataWorker(context: saveContext)
        }
        
        // MARK: - CoreData
        
        // MARK: Fetch stuff
        
        //        defaultContainer.register(NSFetchedResultsController<UserDevice>.self) { (r, delegate: UserListViewController) in
        //            let fr = r.resolve(NSFetchRequest<UserDevice>.self)!
        //            let context = r.resolve(ICDContextManager.self)!.mainContext
        //
        //            let frc = NSFetchedResultsController(fetchRequest: fr.self,
        //                                                 managedObjectContext: context,
        //                                                 sectionNameKeyPath: nil,
        //                                                 cacheName: nil)
        //
        //            frc.delegate = delegate
        //
        //            return frc
        //        }
        //
        //        defaultContainer.register(NSFetchRequest<UserDevice>.self) { r in
        //            let fetchRequestProvider = r.resolve(IFetchRequestProvider.Type.self)!
        //
        //            let sortKey = #keyPath(UserDevice.profile.createdAt)
        //            let creationDateSorter = NSSortDescriptor(key: sortKey, ascending: false)
        //
        //            let fr = fetchRequestProvider.fetchRequest(object: UserDevice.self, sortDescriptors: [creationDateSorter])
        //
        //            return fr
        //        }
        
        defaultContainer.register(IFetchRequestProvider.Type.self) { _ in FetchRequestProvider.self }
        
        // MARK: Stack
        
        defaultContainer.register(ICDStack.self) { _ in CDStack() }.inObjectScope(.container)
        
        defaultContainer.register(ICDContextManager.self) { r in r.resolve(ICDStack.self)! }
        
    }
}

//typealias NewsListModelViewConstraint = (NSFetchedResultsControllerDelegate & NewsListViewDelegate)
//
// protocol IDependencyManager: INewsListDependencyManager, INewsContentDependencyManager {}
//
// protocol INewsListDependencyManager {
//    func newsListModel(for view: NewsListModelViewConstraint) -> INewsListModel
// }
//
// protocol INewsContentDependencyManager {
//    func newsContentModel() -> INewsContentModel
// }
//
// final class DependencyManager: IDependencyManager {
//
//    // MARK: - INewsListDependencyManager
//
//    func newsListModel(for view: NewsListModelViewConstraint) -> INewsListModel {
//        let model = NewsListModel(view: view, dependencies: newsListModelDependencies)
//
//        return model
//
//    }
//
//    // MARK: - INewsContentDependencyManager
//
//    func newsContentModel() -> INewsContentModel {
//        let model = NewsContentModel(contentProvider: newsContentProvider)
//
//        return model
//    }
//
//    // MARK: - Private
//
//    private lazy var newsContentProvider: INewsContentProvider = {
//        let provider = NewsContentProvider(dependencies: self.newsContentProviderDependencies)
//
//        return provider
//    }()
//
//    private lazy var newsListProvider: INewsListProvider = {
//        let provider = NewsListProvider(dependencies: self.newsListProviderDependencies)
//
//        return provider
//    }()
//
//    // MARK: - Dependencies
//
//    private lazy var newsListModelDependencies: NewsListModelDependencies = {
//        let d = NewsListModelDependencies(newsProvider: self.newsListProvider,
//                                          fetchRequestProvider: self.fetchRequestProvider,
//                                          frcManager: self.fetchedResultsControllerManager,
//                                          syncer: self.managedObjectSynchronizer)
//
//        return d
//    }()
//
//    private lazy var newsListProviderDependencies: NewsListProviderDependencies = {
//        let d = NewsListProviderDependencies(requestSender: self.requestSender,
//                                             cacheManager: self.newsListCacheManager,
//                                             coreDataWorker: self.coreDataWorker,
//                                             configBuilder: self.newsListConfigBuilder)
//
//        return d
//    }()
//
//    private lazy var newsContentProviderDependencies: NewsContentProviderDependencies = {
//        let d = NewsContentProviderDependencies(cacheManager: self.newsContentCacheManager,
//                                                requstSender: self.requestSender,
//                                                configBuilder: self.newsContentConfigBuilder)
//
//        return d
//    }()
//
//    // MARK: -
//
//    // MARK: - CoreData
//
//    private lazy var managedObjectSynchronizer: IManagedObjectSynchronizer = {
//        let syncer = ManagedObjectSynchronizer(contextManager: self.contextManager)
//
//        return syncer
//    }()
//
//    private lazy var fetchedResultsControllerManager: IFetchedResultsControllerManager = {
//        let manager = FetchedResultsControllerManager(context: self.mainContext)
//
//        return manager
//    }()
//
//    private lazy var newsContentCacheManager: INewsContentCacheManager = {
//        let manager = NewsContentCacheManager(contextManager: self.contextManager,
//                                              saveContext: self.saveContext,
//                                              coreDataWorker: self.coreDataWorker,
//                                              objectMapper: self.objectMapper)
//
//        return manager
//    }()
//
//    private lazy var newsListCacheManager: INewsListCacheManager = {
//        let manager = NewsListCacheManager(contextManager: self.contextManager,
//                                           saveContext: self.saveContext,
//                                           objectMapper: self.objectMapper,
//                                           coreDataWorker: self.coreDataWorker)
//
//        return manager
//    }()
//
//    private lazy var coreDataWorker: ICoreDataWorker = {
//        let worker = CoreDataWorker(context: self.saveContext)
//
//        return worker
//    }()
//
//    private lazy var mainContext: NSManagedObjectContext = {
//        self.contextManager.mainContext
//    }()
//
//    private lazy var saveContext: NSManagedObjectContext = {
//        self.contextManager.saveContext
//    }()
//
//    private lazy var contextManager: ICDContextManager = {
//        self.stackAssembler
//    }()
//
//    private var stackAssembler: ICDStack {
//        let stack = CDStack()
//
//        return stack
//    }
//
//    // MARK: - Network
//
//    private lazy var newsContentConfigBuilder: INewsContentConfigBuilder = {
//        let builder = NewsContentConfigBuilder()
//
//        return builder
//    }()
//
//    private lazy var newsListConfigBuilder: INewsListConfigBuilder = {
//        let builder = NewsListConfigBuilder()
//
//        return builder
//    }()
//
//    private lazy var requestSender: IRequestSender = {
//        let sender = RequestSender()
//
//        return sender
//    }()
//
//    // MARK: - Static
//
//    private lazy var fetchRequestProvider: IFetchRequestProvider.Type = {
//        FetchRequestProvider.self
//    }()
//
//    private lazy var objectMapper: IStructToEntityMapper.Type = {
//        let mapper = StructToEntityMapper.self
//
//        return mapper
//    }()
// }
