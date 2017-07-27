//
// Created by Evgeniy on 22.07.17.
// Copyright (c) 2017 supreme. All rights reserved.
//

import Foundation
import CoreData

protocol ICDStack: ICDContextManager {
    var managedObjectModel: NSManagedObjectModel { get }
    var persistentStoreCoordinator: NSPersistentStoreCoordinator { get }
}
