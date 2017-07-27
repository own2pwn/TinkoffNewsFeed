//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

protocol INewsListModel: class {
    weak var view: (NewsListViewDelegate & NSFetchedResultsControllerDelegate)! { get set }

    func loadNews(completion: ((String?) -> Void)?)
    func update(batch: Int, completion: @escaping (String?) -> Void)
    func loadMore(_ count: Int, completion: ((String?) -> Void)?)

    var fetchedNewsCount: Int { get }
    func rowsCount(for section: Int) -> Int
    func object(for indexPath: IndexPath) -> News

    func presentNewsContent(for indexPath: IndexPath)
}

extension INewsListModel {
    func loadNews(completion: ((String?) -> Void)? = nil) {
        loadNews(completion: completion)
    }

    func loadMore(_ count: Int, completion: ((String?) -> Void)? = nil) {
        loadMore(count, completion: completion)
    }
}
