//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

protocol IFetchedResultsControllerManager {

    func initialize<Entity:NSManagedObject>(with delegate: NSFetchedResultsControllerDelegate,
                                            fetchRequest: NSFetchRequest<Entity>) -> NSFetchedResultsController<Entity>

    func initialize<Entity:NSManagedObject>(with delegate: NSFetchedResultsControllerDelegate,
                                            fetchRequest: NSFetchRequest<Entity>,
                                            sectionNameKeyPath keyPath: String?,
                                            cacheName: String?) -> NSFetchedResultsController<Entity>
}
