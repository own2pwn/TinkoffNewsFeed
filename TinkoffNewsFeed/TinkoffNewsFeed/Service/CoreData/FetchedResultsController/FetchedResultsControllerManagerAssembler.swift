//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

final class FetchedResultsControllerManagerAssembler: IFetchedResultsControllerManagerAssembler {
    
    class func assembly(mainContext: NSManagedObjectContext) -> IFetchedResultsControllerManager {
        let manager = FetchedResultsControllerManager(context: mainContext)
        
        return manager
    }
    
    class func assembly() -> IFetchedResultsControllerManager {
        let manager = FetchedResultsControllerManager(context: mainContext)
        
        return manager
    }

    private static var mainContext: NSManagedObjectContext {
        let contextManager: ICDContextManager = CDStackAssembler.assembly()

        return contextManager.mainContext
    }
}
