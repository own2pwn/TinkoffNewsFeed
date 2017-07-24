//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

// TODO: move to core layer



final class NewsListCacheManager: INewsListCacheManager {
    func cache(_ news: NewsEntityModel...) {
        for single in news {
            let mObject = News(context: saveContext)

        }
    }

    private func mapModelToObject(_ model: NewsEntityModel) {
        let mObject = News(context: saveContext)

    }

    // TODO: extract to assembler

    init(saveContext: NSManagedObjectContext) {
        self.saveContext = saveContext
    }

    private let saveContext: NSManagedObjectContext
}
