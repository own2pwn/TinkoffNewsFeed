//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

protocol IManagedObjectSynchronizer {
    func sync<Object: NSManagedObject>(_ object: Object, completion: ((Error?) -> Void)?)
}

extension IManagedObjectSynchronizer {
    func sync<Object: NSManagedObject>(_ object: Object, completion: ((Error?) -> Void)? = nil) {
        sync(object, completion: completion)
    }
}
