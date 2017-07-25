//
//  DateExtension.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 25.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

extension Date {
    func time() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        return dateFormatter.string(from: self)
    }

    func day() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"

        return dateFormatter.string(from: self)
    }
}
