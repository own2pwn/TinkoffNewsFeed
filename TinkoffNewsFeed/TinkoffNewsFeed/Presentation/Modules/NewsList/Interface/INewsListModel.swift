//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

protocol INewsListModel: class {
    weak var view: (NewsListViewDelegate & NSFetchedResultsControllerDelegate)! { get set }
    
    func loadNews()
    func update(_ batch: Int)
    func loadMore(_ count: Int)

    var fetchedNewsCount: Int { get }
    func rowsCount(for section: Int) -> Int
    func displayModel(for indexPath: IndexPath) -> NewsListDisplayModel

    func presentNewsContent(for indexPath: IndexPath)
}
