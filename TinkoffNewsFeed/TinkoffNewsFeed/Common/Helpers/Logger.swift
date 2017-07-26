//
// Created by supreme on 19/07/2017.
// Copyright (c) 2017 supreme. All rights reserved.
//

import Foundation
import SwiftyBeaver

let log = SwiftyBeaver.self

open class Logger {
    static func setupLogging() -> Bool {
        let console = ConsoleDestination()
        log.addDestination(console)
        log.info("Starting new instance!")
        
        return true
    }
}
