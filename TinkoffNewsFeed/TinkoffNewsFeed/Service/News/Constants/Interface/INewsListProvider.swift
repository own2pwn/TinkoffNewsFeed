//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol INewsListProvider {
    func update(offset: Int, count: Int, completion: ((String?) -> Void)?)
    func load(offset: Int, count: Int, completion: ((String?) -> Void)?)
    func loadCached(offset: Int, completion: @escaping ([News]?) -> Void)
}

extension INewsListProvider {

    func update(offset: Int = 0, count: Int, completion: ((String?) -> Void)? = nil) {
        update(offset: offset, count: count, completion: completion)
    }

    func load(offset: Int = 0, count: Int, completion: ((String?) -> Void)? = nil) {
        load(offset: offset, count: count, completion: completion)
    }
}
