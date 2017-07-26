//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

extension NSAttributedString {
    func makeRange(_ start: Int = 0) -> NSRange {
        let nsString = self.string as NSString
        let range = NSMakeRange(start, nsString.length)

        return range
    }
}
