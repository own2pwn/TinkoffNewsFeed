//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

struct NewsListModelDependencies {
    let newsProvider: INewsListProvider
    let fetchRequestProvider: IFetchRequestProvider.Type
    let frcManager: IFetchedResultsControllerManager
    let syncer: IManagedObjectSynchronizer
}

final class NewsListModel: INewsListModel {

    // MARK: - INewsListModel

    weak var view: (NewsListViewDelegate & NSFetchedResultsControllerDelegate)!

    func loadNews() {
        view.startLoadingAnimation()
        newsProvider.load(count: newsBatchSize) { [unowned self] in
            self.view.stopLoadingAnimation()
            log.debug("News were loaded from API")
        }
    }

    func update(_ batch: Int) {
        
    }
    
    func loadMore(_ count: Int) {

    }

    func presentNewsContent(for indexPath: IndexPath) {
        let object = frc.object(at: indexPath)
        let id = object.id!
        let title = object.title!
        let content = object.content?.content
        object.viewsCount += 1
        syncer.sync(object) { (error) in
            if let e = error {
                log.debug("Error while syncing: \(e)!")
            }
        }

        let model = NewsContentRoutingModel(id: id, title: title, content: content)
        view.presentNewsDetails(model)
    }

    var fetchedNewsCount: Int {
        return rowsCount(for: 0)
    }
    
    func rowsCount(for section: Int) -> Int {
        let sections = frc.sections!
        let sectionInfo = sections[section]

        return sectionInfo.numberOfObjects
    }

    func displayModel(for indexPath: IndexPath) -> NewsListDisplayModel {
        let object = frc.object(at: indexPath)
        // TODO: date formatting
        let date = object.pubDate! as Date
        let viewsCount = Int(object.viewsCount)
        let title = object.title!

        let model = NewsListDisplayModel(date: date, viewsCount: viewsCount, title: title)

        return model
    }

    // MARK: - Members

    private var frc: NSFetchedResultsController<News>!
    
    // MARK: - Methods
    
    private func initFRC() {
        let dateSorter = NSSortDescriptor(key: sortByKey, ascending: false)
        let sortDescriptors = [dateSorter]
        let fr = fetchRequestProvider.fetchRequest(object: News.self, sortDescriptors: sortDescriptors, predicate: nil, fetchLimit: newsBatchSize)
        fr.fetchBatchSize = newsBatchSize
        
        frc = frcManager.initialize(delegate: view, fetchRequest: fr)
        try? frc.performFetch()
    }
    
    // MARK: - Constants
    
    private let newsBatchSize = 20
    private let sortByKey = "pubDate"

    // MARK: - DI

    init(view: (NewsListViewDelegate & NSFetchedResultsControllerDelegate), dependencies: NewsListModelDependencies) {
        self.view = view

        newsProvider = dependencies.newsProvider
        fetchRequestProvider = dependencies.fetchRequestProvider
        frcManager = dependencies.frcManager
        syncer = dependencies.syncer
        
        initFRC()
    }

    private let newsProvider: INewsListProvider
    private let fetchRequestProvider: IFetchRequestProvider.Type
    private let frcManager: IFetchedResultsControllerManager
    private let syncer: IManagedObjectSynchronizer
}
