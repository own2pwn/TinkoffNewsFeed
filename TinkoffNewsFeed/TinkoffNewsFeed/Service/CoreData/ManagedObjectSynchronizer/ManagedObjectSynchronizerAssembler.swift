//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

final class ManagedObjectSynchronizerAssembler: IManagedObjectSynchronizerAssembler {
    class func assembly() -> IManagedObjectSynchronizer {
        let syncer = ManagedObjectSynchronizer(contextManager: contextManager)
    }

    // MARK: - Private

    private static var contextManager: ICDContextManager {
        return CDStackAssembler.assembly()
    }
}
