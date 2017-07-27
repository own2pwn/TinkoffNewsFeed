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

protocol IDependencyManager: INewsListDependencyManager, INewsContentDependencyManager {}

protocol INewsListDependencyManager {
    func newsListModel(for view: NewsListModelViewConstraint) -> INewsListModel
}

protocol INewsContentDependencyManager {
    func newsContentModel() -> INewsContentModel
}

// TODO: maybe make only CD stack static lazy

final class DependencyManager: IDependencyManager {

    // MARK: - INewsListDependencyManager

    func newsListModel(for view: NewsListModelViewConstraint) -> INewsListModel {
        let model = NewsListModel(view: view, dependencies: newsListModelDependencies)

        return model

    }

    // MARK: - INewsContentDependencyManager

    func newsContentModel() -> INewsContentModel {
        let model = NewsContentModel(contentProvider: newsContentProvider)

        return model
    }

    // MARK: - Private

    private lazy var newsContentProvider: INewsContentProvider = {
        let provider = NewsContentProvider(dependencies: self.newsContentProviderDependencies)

        return provider
    }()

    private lazy var newsListProvider: INewsListProvider = {
        let provider = NewsListProvider(dependencies: self.newsListProviderDependencies)

        return provider
    }()

    // MARK: - Dependencies

    private lazy var newsListModelDependencies: NewsListModelDependencies = {
        let d = NewsListModelDependencies(newsProvider: self.newsListProvider,
                                          fetchRequestProvider: self.fetchRequestProvider,
                                          frcManager: self.fetchedResultsControllerManager,
                                          syncer: self.managedObjectSynchronizer)

        return d
    }()

    private lazy var newsListProviderDependencies: NewsListProviderDependencies = {
        let d = NewsListProviderDependencies(requestSender: self.requestSender,
                                             cacheManager: self.newsListCacheManager,
                                             coreDataWorker: self.coreDataWorker,
                                             contextManager: self.contextManager,
                                             configBuilder: self.newsListConfigBuilder)

        return d
    }()

    private lazy var newsContentProviderDependencies: NewsContentProviderDependencies = {
        let d = NewsContentProviderDependencies(contextManager: self.contextManager,
                                                coreDataWorker: self.coreDataWorker,
                                                objectMapper: self.objectMapper,
                                                cacheManager: self.newsContentCacheManager,
                                                requstSender: self.requestSender,
                                                configBuilder: self.newsContentConfigBuilder)

        return d
    }()

    // MARK: -

    // MARK: - CoreData

    private lazy var managedObjectSynchronizer: IManagedObjectSynchronizer = {
        let syncer = ManagedObjectSynchronizer(contextManager: self.contextManager)

        return syncer
    }()

    private lazy var fetchedResultsControllerManager: IFetchedResultsControllerManager = {
        let manager = FetchedResultsControllerManager(context: self.mainContext)

        return manager
    }()

    private lazy var newsContentCacheManager: INewsContentCacheManager = {
        let manager = NewsContentCacheManager(contextManager: self.contextManager,
                                              saveContext: self.saveContext,
                                              coreDataWorker: self.coreDataWorker,
                                              objectMapper: self.objectMapper)

        return manager
    }()

    private lazy var newsListCacheManager: INewsListCacheManager = {
        let manager = NewsListCacheManager(contextManager: self.contextManager,
                                           saveContext: self.saveContext,
                                           objectMapper: self.objectMapper,
                                           coreDataWorker: self.coreDataWorker)

        return manager
    }()

    private lazy var coreDataWorker: ICoreDataWorker = {
        let worker = CoreDataWorker(context: self.saveContext)

        return worker
    }()

    private lazy var mainContext: NSManagedObjectContext = {
        self.contextManager.mainContext
    }()

    private lazy var saveContext: NSManagedObjectContext = {
        self.contextManager.saveContext
    }()

    private lazy var contextManager: ICDContextManager = {
        self.stackAssembler
    }()

    private var stackAssembler: ICDStack {
        let stack = CDStack()

        return stack
    }

    // MARK: - Network

    private lazy var newsContentConfigBuilder: INewsContentConfigBuilder = {
        let builder = NewsContentConfigBuilder()

        return builder
    }()

    private lazy var newsListConfigBuilder: INewsListConfigBuilder = {
        let builder = NewsListConfigBuilder()

        return builder
    }()

    private lazy var requestSender: IRequestSender = {
        let sender = RequestSender()

        return sender
    }()

    // MARK: - Static

    private lazy var fetchRequestProvider: IFetchRequestProvider.Type = {
        FetchRequestProvider.self
    }()

    private lazy var objectMapper: IStructToEntityMapper.Type = {
        let mapper = StructToEntityMapper.self

        return mapper
    }()
}
