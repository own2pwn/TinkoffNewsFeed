//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

protocol INewsListAssembler {
    static func assembly(for view: (NewsListViewDelegate & NSFetchedResultsControllerDelegate)) -> NewsListDependencies
}
