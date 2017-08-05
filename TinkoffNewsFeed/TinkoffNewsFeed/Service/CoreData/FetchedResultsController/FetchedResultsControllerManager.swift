//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

final class FetchedResultsControllerManager: IFetchedResultsControllerManager {

    // MARK: - FetchedResultsControllerManager

    func initialize<Entity: NSManagedObject>(delegate: NSFetchedResultsControllerDelegate,
                                             fetchRequest: NSFetchRequest<Entity>) -> NSFetchedResultsController<Entity> {
        return initialize(delegate: delegate,
                          fetchRequest: fetchRequest,
                          sectionNameKeyPath: nil,
                          cacheName: nil)
    }

    func initialize<Entity: NSManagedObject>(delegate: NSFetchedResultsControllerDelegate,
                                             fetchRequest: NSFetchRequest<Entity>,
                                             sectionNameKeyPath keyPath: String? = nil,
                                             cacheName: String? = nil) -> NSFetchedResultsController<Entity> {

        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: uiContext,
                                             sectionNameKeyPath: keyPath,
                                             cacheName: cacheName)
        frc.delegate = delegate

        return frc
    }

    // MARK: - DI

    init(uiContext: NSManagedObjectContext) {
        self.uiContext = uiContext
    }

    private let uiContext: NSManagedObjectContext
}
