//
// Created by Evgeniy on 25.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol INewsContentProvider {
    func load(by id: String, completion: @escaping (NewsContentDisplayModel) -> Void)
}
