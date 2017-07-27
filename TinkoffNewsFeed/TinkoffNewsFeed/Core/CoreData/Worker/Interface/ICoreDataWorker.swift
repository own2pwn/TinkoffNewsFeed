//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

protocol ICoreDataWorker {
    func find<T: NSManagedObject>(by attribute: String, value: String, entity: T.Type) -> [T]?

    func findFirst<T: NSManagedObject>(by attribute: String, value: String, entity: T.Type) -> T?

    func getDict<T: NSManagedObject>(type: T.Type,
                                     predicate: NSPredicate?,
                                     propertiesToFetch: [String]?,
                                     sortDescriptors: [NSSortDescriptor]?,
                                     fetchLimit: Int?) -> [Any]?

    func get<T: NSManagedObject>(type: T.Type,
                                 predicate: NSPredicate?,
                                 sortDescriptors: [NSSortDescriptor]?,
                                 offset: Int?,
                                 fetchLimit: Int?) -> [T]?

    func getFirst<T: NSManagedObject>(type: T.Type,
                                      predicate: NSPredicate?,
                                      sortDescriptors: [NSSortDescriptor]?,
                                      fetchLimit: Int?) -> T?
}

extension ICoreDataWorker {

    func getDict<T: NSManagedObject>(type: T.Type,
                                     predicate: NSPredicate? = nil,
                                     propertiesToFetch: [String]? = nil,
                                     sortDescriptors: [NSSortDescriptor]? = nil,
                                     fetchLimit: Int? = nil) -> [Any]? {
        return getDict(type: type,
                       predicate: predicate,
                       propertiesToFetch: propertiesToFetch,
                       sortDescriptors: sortDescriptors,
                       fetchLimit: fetchLimit)
    }

    func get<T: NSManagedObject>(type: T.Type,
                                 predicate: NSPredicate? = nil,
                                 sortDescriptors: [NSSortDescriptor]? = nil,
                                 offset: Int? = nil,
                                 fetchLimit: Int? = nil) -> [T]? {
        return get(type: type,
                   predicate: predicate,
                   sortDescriptors: sortDescriptors,
                   offset: offset,
                   fetchLimit: fetchLimit)
    }

    func getFirst<T: NSManagedObject>(type: T.Type,
                                      predicate: NSPredicate? = nil,
                                      sortDescriptors: [NSSortDescriptor]? = nil,
                                      fetchLimit: Int? = nil) -> T? {
        return getFirst(type: type,
                        predicate: predicate,
                        sortDescriptors: sortDescriptors,
                        fetchLimit: fetchLimit)
    }
}
