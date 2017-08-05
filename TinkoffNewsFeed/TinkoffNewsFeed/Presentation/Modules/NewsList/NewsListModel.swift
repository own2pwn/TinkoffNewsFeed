//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

typealias NewsListModelViewDependency = (NSFetchedResultsControllerDelegate & NewsListViewDelegate)

struct NewsListModelDependencies {
    let newsProvider: INewsListProvider
    let fetchRequestProvider: IFetchRequestProvider.Type
    let frcManager: IFetchedResultsControllerManager
    let syncer: IManagedObjectSynchronizer
}

final class NewsListModel: INewsListModel {

    // MARK: - INewsListModel

    weak var view: (NewsListViewDelegate & NSFetchedResultsControllerDelegate)!

    func loadNews(completion: ((String?) -> Void)?) {
        view.startLoadingAnimation()
        newsProvider.load(count: newsBatchSize) { [unowned self] error in
            self.view.stopLoadingAnimation()
            completion?(error)
        }
    }

    func update(batch: Int, completion: @escaping (String?) -> Void) {
        view.startLoadingAnimation()
        newsProvider.update(count: batch) { [unowned self] error in
            self.view.stopLoadingAnimation()
            completion(error)
        }
    }

    func loadMore(_ count: Int, completion: ((String?, Int, Bool) -> Void)?) {
        let countBefore = fetchedNewsCount
        frc.fetchRequest.fetchLimit = countBefore + count
        try? frc.performFetch()
        let countAfter = fetchedNewsCount
        let diff = countAfter - countBefore

        if diff < newsBatchSize {
            let missingNews = count - diff
            log.debug("asking api for: \(missingNews) news")

            newsProvider.load(offset: countAfter, count: missingNews, completion: { [unowned self] error in
                let newCount = self.fetchedNewsCount
                let newDiff = newCount - countAfter
                completion?(error, newDiff, true)
            })
        } else {
            completion?(nil, diff, false)
        }
    }

    func presentNewsContent(for indexPath: IndexPath) {
        let object = frc.object(at: indexPath)
        updateViewsCount(for: object)
        view.presentNewsDetails(object)
    }

    var fetchedNewsCount: Int {
        return rowsCount(for: 0)
    }

    func rowsCount(for section: Int) -> Int {
        return frc.fetchedObjects!.count
    }

    func object(for indexPath: IndexPath) -> News {
        let object = frc.object(at: indexPath)

        return object
    }

    // MARK: - Members

    private var frc: NSFetchedResultsController<News>!

    // MARK: - Methods

    private func initFRC() {
        let dateSorter = NSSortDescriptor(key: sortByKey, ascending: false)
        let sortDescriptors = [dateSorter]
        let fr = fetchRequestProvider.fetchRequest(object: News.self, sortDescriptors: sortDescriptors, predicate: nil, fetchLimit: newsBatchSize)
        fr.fetchBatchSize = 2 * newsBatchSize

        frc = frcManager.initialize(delegate: view, fetchRequest: fr)
        try? frc.performFetch()
    }

    private func updateViewsCount(for object: News) {
        object.viewsCount += 1
        syncer.sync(object) { error in
            if let e = error {
                log.debug("Error incrementing views count: \(e)!")
            }
        }
    }

    // MARK: - Constants

    private let newsBatchSize: Int = .TNF_API_REQUEST_NEWS_BATCH_SIZE
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
