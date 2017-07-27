//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

final class FetchRequestProvider: IFetchRequestProvider {

    // MARK: - IFetchRequestProvider

    class func fetchRequest<Object: NSManagedObject>(object: Object.Type) -> NSFetchRequest<Object> {

        return fetchRequest(object: object,
                            sortDescriptors: nil,
                            predicate: nil,
                            fetchLimit: nil)
    }

    class func fetchRequest<Object: NSManagedObject>(object: Object.Type,
                                                     sortDescriptors: [NSSortDescriptor]? = nil,
                                                     predicate: NSPredicate? = nil,
                                                     fetchLimit: Int? = nil) -> NSFetchRequest<Object> {
        let name = Object.entityName
        let fr = NSFetchRequest<Object>(entityName: name)
        fr.sortDescriptors = sortDescriptors
        fr.predicate = predicate
        if let limit = fetchLimit {
            fr.fetchLimit = limit
        }

        return fr
    }
}
