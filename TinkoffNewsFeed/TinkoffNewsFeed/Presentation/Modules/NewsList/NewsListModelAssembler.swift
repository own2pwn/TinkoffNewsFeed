//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

final class NewsListModelDependenciesAssembler {
    class func assembly() -> NewsListModelDependencies {
        let d = NewsListModelDependencies(newsProvider: newsListProvider,
                                          fetchRequestProvider: fetchRequestProvider,
                                          frcManager: fetchedResultsControllerManager,
                                          syncer: managedObjectSynchronizer)
        
        return d
    }

    // MARK: - Private

    private static var newsListProvider: INewsListProvider {
        return NewsListProviderAssembler.assembly()
    }

    private static var fetchRequestProvider: IFetchRequestProvider.Type {
        return FetchRequestProviderAssembler.assembly()
    }

    private static var fetchedResultsControllerManager: IFetchedResultsControllerManager {
        return FetchedResultsControllerManagerAssembler.assembly()
    }

    private static var managedObjectSynchronizer: IManagedObjectSynchronizer {
        return ManagedObjectSynchronizerAssembler.assembly()
    }

    private static var requestSender: IRequestSender {
        return RequestSenderAssembler.assembly()
    }
}
