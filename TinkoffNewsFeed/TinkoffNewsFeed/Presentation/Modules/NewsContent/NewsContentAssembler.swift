//
//  NewsContentAssembler.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 26.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

final class NewsContentAssembler: INewsContentAssembler {
    class func assembly() -> NewsContentDependencies {
        let d = NewsContentDependencies(model: newsContentModel)

        return d
    }

    // MARK: - Private

    private static var newsContentModel: INewsContentModel {
        return NewsContentModelAssembler.assembly()
    }
}
