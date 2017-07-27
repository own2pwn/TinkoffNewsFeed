//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

final class ManagedObjectSynchronizer: IManagedObjectSynchronizer {

    // MARK: - IManagedObjectSynchronizer

    func sync<Object: NSManagedObject>(_ object: Object, completion: ((Error?) -> Void)? = nil) {
        let ctx = object.managedObjectContext!
        
        queue.sync {
            contextManager.performSave(context: ctx, completion: completion)
        }
    }

    // MARK: - DI

    init(contextManager: ICDContextManager) {
        self.contextManager = contextManager
    }

    private let contextManager: ICDContextManager

    private let queue = DispatchQueue(label: "tnf.service")
}
