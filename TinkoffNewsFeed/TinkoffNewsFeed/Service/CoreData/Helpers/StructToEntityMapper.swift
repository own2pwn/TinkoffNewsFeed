//
// Created by Evgeniy on 24.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

import Foundation
import CoreData

final class StructToEntityMapper: IStructToEntityMapper {

    // MARK: - IStructToEntityMapper

    class func map<T>(_ model: IEntityMappable, _ object: inout T) {
        let object = object as! NSManagedObject
        let entity = object.entity
        let attributes = entity.attributesByName

        for attribute in attributes.keys {
            let modelValue = model[attribute]
            object.setValue(modelValue, forKeyPath: attribute)
        }
    }

    // MARK: - Private

    private init() {}
}
