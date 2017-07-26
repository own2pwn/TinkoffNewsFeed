//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

final class NewsListModelAssembler {
    class func assembly() -> INewsListModel {
        let model = NewsListModel(view: <#T##(NewsListViewDelegate & NSFetchedResultsControllerDelegate)##(TinkoffNewsFeed.NewsListViewDelegate & CoreData.NSFetchedResultsControllerDelegate)#>, dependencies: <#T##NewsListModelDependencies##TinkoffNewsFeed.NewsListModelDependencies#>)
    }

    // MARK: - Private

    private class func assemblyDependencies() -> NewsListModelDependencies {
        let d = NewsListModelDependencies(newsProvider: <#T##INewsListProvider##TinkoffNewsFeed.INewsListProvider#>, fetchRequestProvider: <#T##IFetchRequestProvider.Protocol##TinkoffNewsFeed.IFetchRequestProvider.Protocol#>, frcManager: <#T##IFetchedResultsControllerManager##TinkoffNewsFeed.IFetchedResultsControllerManager#>, syncer: <#T##IManagedObjectSynchronizer##TinkoffNewsFeed.IManagedObjectSynchronizer#>)
    }

    private static var newsListProvider: INewsContentProvider {

    }
}
