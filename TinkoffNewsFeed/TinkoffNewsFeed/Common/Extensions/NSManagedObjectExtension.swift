//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    static var entityName: String {
        let name = String(describing: self)

        return name
    }
}
