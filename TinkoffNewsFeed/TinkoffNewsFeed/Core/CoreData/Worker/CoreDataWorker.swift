//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataWorker: ICoreDataWorker {

    // MARK: - ICoreDataWorker

    func find<T:NSManagedObject>(by attribute: String, value: String, entity: T.Type) -> [T]? {
        let name = T.entityName
        let fr = NSFetchRequest<T>(entityName: name)
        let predicate = NSPredicate(format: "%K == %@", attribute, value)
        fr.predicate = predicate

        let result = try? context.fetch(fr)

        return result
    }

    func findFirst<T:NSManagedObject>(by attribute: String, value: String, entity: T.Type) -> T? {
        let result = find(by: attribute, value: value, entity: entity)

        return result?.first
    }

    //TODO: use threads

    func get<T:NSManagedObject>(type: T.Type,
                                predicate: NSPredicate? = nil,
                                sortDescriptors: [NSSortDescriptor]? = nil,
                                fetchLimit: Int? = nil) -> [T]? {
        let name = T.entityName
        let fr = NSFetchRequest<T>(entityName: name)
        fr.predicate = predicate
        fr.sortDescriptors = sortDescriptors
        if let limit = fetchLimit {
            fr.fetchLimit = limit
        }
        let result = try? context.fetch(fr)

        return result as? [T]
    }

    func getFirst<T:NSManagedObject>(type: T.Type,
                                     predicate: NSPredicate? = nil,
                                     sortDescriptors: [NSSortDescriptor]? = nil,
                                     fetchLimit: Int? = nil) -> T? {
        return get(type: type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit)?.first
    }

    // MARK: - DI

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    private let context: NSManagedObjectContext
}
