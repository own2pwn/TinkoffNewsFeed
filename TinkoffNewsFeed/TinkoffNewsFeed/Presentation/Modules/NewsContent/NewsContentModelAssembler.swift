//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

final class NewsContentModelAssembler: INewsContentModelAssembler {
    class func assembly() -> INewsContentModel {
        let model = NewsContentModel(contentProvider: newsContentProvider)

        return model
    }

    // MARK: - Private

    private static var newsContentProvider: INewsContentProvider {
        return NewsContentProviderAssembler.assembly()
    }
}
