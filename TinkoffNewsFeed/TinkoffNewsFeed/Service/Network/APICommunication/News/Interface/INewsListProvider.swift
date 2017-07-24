//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol INewsListProvider {
    func load(offset: Int, count: Int,
              completion: (() -> Void)?)
}

extension INewsListProvider {
    func load(offset: Int = 0, count: Int,
              completion: (() -> Void)? = nil) {
        load(offset: offset, count: count, completion: completion)
    }
}
