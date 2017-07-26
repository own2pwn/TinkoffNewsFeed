//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

protocol ICoreDataWorker {
    func find<T:NSManagedObject>(by attribute: String, value: String, entity: T.Type) -> [T]?

    func findFirst<T:NSManagedObject>(by attribute: String, value: String, entity: T.Type) -> T?

    func get<T:NSManagedObject>(type: T.Type,
                                predicate: NSPredicate?,
                                sortDescriptors: [NSSortDescriptor]?,
                                fetchLimit: Int?) -> [T]?

    func getFirst<T:NSManagedObject>(type: T.Type,
                                     predicate: NSPredicate?,
                                     sortDescriptors: [NSSortDescriptor]?,
                                     fetchLimit: Int?) -> T?
}

extension ICoreDataWorker {
    func get<T:NSManagedObject>(type: T.Type,
                                predicate: NSPredicate? = nil,
                                sortDescriptors: [NSSortDescriptor]? = nil,
                                fetchLimit: Int? = nil) -> [T]? {
        return get(type: type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit)
    }

    func getFirst<T:NSManagedObject>(type: T.Type,
                                     predicate: NSPredicate? = nil,
                                     sortDescriptors: [NSSortDescriptor]? = nil,
                                     fetchLimit: Int? = nil) -> T? {
        return getFirst(type: type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit)
    }
}