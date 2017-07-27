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
        // TODO: frc.obj.count
        // or my func?

        let countBefore = fetchedNewsCount
        frc.fetchRequest.fetchLimit += count
        try? frc.performFetch()
        let countAfter = fetchedNewsCount
        let diff = countAfter - countBefore

        if diff < newsBatchSize {
            let missingNews = count - diff
            log.debug("asking api for: \(missingNews) news")
            
            newsProvider.load(offset: countAfter, count: missingNews, completion: { [unowned self] (error) in
                let newCount = self.fetchedNewsCount
                if newCount == countAfter {
                    //no news from api
                }
                let newDiff = newCount - countAfter + missingNews
                //check new diff == 0
                try? self.frc.performFetch()
                completion?(error, newDiff, true)
            })
        } else {
            completion?(nil, diff, false)
        }
    }

    func presentNewsContent(for indexPath: IndexPath) {
        let object = frc.object(at: indexPath)
        let id = object.id!
        let title = object.title!
        let content = object.content?.content
        object.viewsCount += 1
        syncer.sync(object) { error in
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
