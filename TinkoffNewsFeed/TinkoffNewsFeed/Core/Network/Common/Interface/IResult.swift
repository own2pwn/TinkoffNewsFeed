//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

enum IResult<T> {
    case error(String)
    case success(T)
}