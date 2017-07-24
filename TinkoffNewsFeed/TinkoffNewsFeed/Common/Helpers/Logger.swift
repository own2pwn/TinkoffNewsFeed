//
// Created by supreme on 19/07/2017.
// Copyright (c) 2017 supreme. All rights reserved.
//

import Foundation
import SwiftyBeaver

let log = SwiftyBeaver.self

open class Logger {
    static func setupLogging() {
        let console = ConsoleDestination()
        let file = FileDestination()
        file.logFileURL = URL(string: logFilePath)
        FileManager.default.createFile(atPath: logFilePath, contents: nil, attributes: nil)

        log.addDestination(console)
        log.addDestination(file)

        log.info("Starting new instance!")
    }

    // MARK: - Private properties

    private static let logFilePath = "/Volumes/V512/Dev/TNF.txt"
}
