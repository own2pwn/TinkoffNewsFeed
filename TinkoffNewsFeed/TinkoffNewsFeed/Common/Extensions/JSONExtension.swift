//
// Created by Evgeniy on 25.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    /**
     Find a json in the complex data structures by using array of Int and/or String as path.

     - parameter path: The target json's path. Example:

     let name = json[.enumInt, .enumString, .string, .name]

     The same as: let name = json[.enumInt][.enumString][.string][.name]

     - returns: Return a json found by the path or a null json with error
     */
    subscript(_ key: String...) -> JSON {
        get {
            return self[key]
        }
        set {
            self[key] = newValue
        }
    }
}
