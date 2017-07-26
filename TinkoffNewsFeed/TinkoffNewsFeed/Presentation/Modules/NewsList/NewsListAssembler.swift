//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

final class NewsListAssembler: INewsListAssembler {
    class func assembly(for view: (NewsListViewDelegate & NSFetchedResultsControllerDelegate)) -> NewsListDependencies {
        let model = buildModel(view)
        let d = NewsListDependencies(model: model)

        return d
    }

    // MARK: - Private

    private typealias viewDependency = (NewsListViewDelegate & NSFetchedResultsControllerDelegate)

    private class func buildModel(_ view: viewDependency) -> INewsListModel {
        let model = NewsListModel(view: view, dependencies: newsListModelDependencies)

        return model
    }

    private static var newsListModelDependencies: NewsListModelDependencies {
        return NewsListModelDependenciesAssembler.assembly()
    }
}
