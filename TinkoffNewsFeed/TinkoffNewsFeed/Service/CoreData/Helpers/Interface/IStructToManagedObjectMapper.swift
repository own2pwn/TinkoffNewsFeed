//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol IStructToManagedObjectMapper {
    static func map<T>(_ model: IManagedObjectMappable, _ object: inout T)
}
