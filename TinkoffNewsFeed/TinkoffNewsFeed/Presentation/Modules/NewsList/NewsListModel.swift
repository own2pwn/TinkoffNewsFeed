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
        let cachedNews = initFRC()

        // TODO: if no internet then dont use api

        if cachedNews == 0 {
            newsProvider.load(count: newsBatchSize, completion: { [unowned self] in
                self.view.stopLoadingAnimation()
                log.debug("Loaded news from api")
            })
            log.debug("there are not any cached news!")
        } else {
            view.stopLoadingAnimation()
        }
    }

    private func initFRC() -> Int {
        let dateSorter = NSSortDescriptor(key: sortByKey, ascending: false)
        let sortDescriptors = [dateSorter]
        let fr = fetchRequestProvider.fetchRequest(object: News.self, sortDescriptors: sortDescriptors, predicate: nil, fetchLimit: newsBatchSize)
        // TODO: extract to a const
        fr.fetchBatchSize = newsBatchSize

        frc = frcManager.initialize(delegate: view, fetchRequest: fr)
        try? frc.performFetch()
        let fetchedNewsCount = frc.sections?[0].numberOfObjects

        return fetchedNewsCount ?? 0
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
            } else {
                log.debug("successfully have synced obj!")
            }
        }

        let model = NewsContentRoutingModel(id: id, title: title, content: content)
        view.presentNewsDetails(model)
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
