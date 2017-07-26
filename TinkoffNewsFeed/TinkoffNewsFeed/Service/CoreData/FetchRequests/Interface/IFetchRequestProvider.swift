//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

protocol IFetchRequestProvider: INewsFetchRequestProvider {

    static func fetchRequest<Object:NSManagedObject>(object: Object.Type) -> NSFetchRequest<Object>

    static func fetchRequest<Object:NSManagedObject>(object: Object.Type,
                                                     sortDescriptors: [NSSortDescriptor]?,
                                                     predicate: NSPredicate?,
                                                     fetchLimit: Int?) -> NSFetchRequest<Object>
}
