//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

final class NewsContentProviderAssembler: INewsContentProviderAssembler {
    class func assembly() -> INewsContentProvider {
        let provider = NewsContentProvider()

        return provider
    }
}
