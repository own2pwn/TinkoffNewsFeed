//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

typealias NewsListModelViewDependency = (NSFetchedResultsControllerDelegate & NewsListViewDelegate)

struct NewsListModelDependencies {
    let newsProvider: INewsListProvider
    let frc: NSFetchedResultsController<News>
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

    // MARK: - Methods

    private func initFetch() {
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

    // MARK: - DI

    init(view: (NewsListViewDelegate & NSFetchedResultsControllerDelegate), dependencies: NewsListModelDependencies) {
        self.view = view

        newsProvider = dependencies.newsProvider
        frc = dependencies.frc
        syncer = dependencies.syncer

        initFetch()
    }

    private let newsProvider: INewsListProvider
    private let frc: NSFetchedResultsController<News>
    private let syncer: IManagedObjectSynchronizer
}
