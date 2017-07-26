//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

final class NewsListProviderAssembler: INewsListProviderAssembler {
    class func assembly() -> INewsListProvider {
        let provider = NewsListProvider(cacheManager: cacheManager, requestSender: requestSender)

        return provider
    }

    // MARK: - Private

    private static var cacheManager: INewsListCacheManager {
        return NewsListCacheManagerAssembler.assembly()
    }

    private static var requestSender: IRequestSender {
        return RequestSenderAssembler.assembly()
    }
}
