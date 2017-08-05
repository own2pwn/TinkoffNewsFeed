//
// Created by Evgeniy on 22.07.17.
// Copyright (c) 2017 supreme. All rights reserved.
//

import Foundation
import CoreData

protocol ICDContextManager {

    func performSave(context: NSManagedObjectContext,
                     completion: ((Error?) -> Void)?)

    var mainContext: NSManagedObjectContext { get }
    var saveContext: NSManagedObjectContext { get }
}

extension ICDContextManager {
    func performSave(context: NSManagedObjectContext,
                     completion: ((Error?) -> Void)? = nil) {
        performSave(context: context, completion: completion)
    }
}
