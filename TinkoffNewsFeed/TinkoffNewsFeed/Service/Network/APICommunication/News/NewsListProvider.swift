//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

private struct NewsListResponse {
    let statusCode: String
    //let payload:
}

struct NewsListAPIModel {
    let newsId: String
    let name: String
    let title: String
    let publicationDate: String
}

final class NewsListProvider: INewsListProvider {
    // func load
}
