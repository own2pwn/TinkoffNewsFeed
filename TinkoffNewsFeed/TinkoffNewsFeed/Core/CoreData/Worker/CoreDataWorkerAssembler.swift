//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataWorkerAssembler: ICoreDataWorkerAssembler {
    class func assembly() -> ICoreDataWorker {
        let worker = CoreDataWorker(context: saveContext)

        return worker
    }

    private static var saveContext: NSManagedObjectContext {
        let contextManager: ICDContextManager = CDStackAssembler.assembly()

        return contextManager.saveContext
    }
}
