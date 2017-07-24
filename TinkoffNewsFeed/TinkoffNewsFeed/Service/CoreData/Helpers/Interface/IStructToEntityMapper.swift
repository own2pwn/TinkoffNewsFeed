//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol IStructToEntityMapper {
    static func map<T>(_ model: IEntityMappable, _ object: inout T)
}
