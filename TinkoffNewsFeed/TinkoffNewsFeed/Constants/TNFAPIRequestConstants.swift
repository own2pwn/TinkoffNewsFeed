//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

enum CTNFAPIRequest {
    static let TNF_NEWS_BATCH_SIZE = 20
}

extension Int {
    static let TNF_NEWS_BATCH_SIZE = CTNFAPIRequest.TNF_NEWS_BATCH_SIZE
}