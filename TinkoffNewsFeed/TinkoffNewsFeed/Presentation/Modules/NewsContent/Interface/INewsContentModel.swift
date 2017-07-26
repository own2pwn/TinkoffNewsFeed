//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol INewsContentModel: class {
    weak var view: NewsContentViewDelegate! { get set }
    func loadNewsContent(by id: String, completion: (() -> Void)?)
}

extension INewsContentModel {
    func loadNewsContent(by id: String, completion: (() -> Void)? = nil) {
        loadNewsContent(by: id, completion: completion)
    }
}