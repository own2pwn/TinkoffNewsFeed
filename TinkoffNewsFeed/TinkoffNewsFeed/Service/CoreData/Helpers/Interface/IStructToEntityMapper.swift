//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol IStructToEntityMapper {

    /**
     
     Maps KVC-compliant object values to `object` ones.
     
     Simple iterates through passed object attributes
     and uses `setValue` where
     
     - `keyPath` is *attribute name*.
     - `value`   is object member with *the same* name value or nil if there is no such member.
     
     - Parameter model: Object that conforms to KVC
     
     - Parameter object: Generic `NSManagedObject`
     
    */
    static func map<T>(_ model: IEntityMappable, _ object: inout T)
}
