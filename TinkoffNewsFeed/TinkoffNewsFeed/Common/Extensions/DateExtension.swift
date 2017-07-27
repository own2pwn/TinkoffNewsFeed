//
//  DateExtension.swift
//  TinkoffNewsFeed
//
//  Created by Evgeniy on 25.07.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

extension Date {

    // MARK: - String

    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        return dateFormatter.string(from: self)
    }

    var dayMonthYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"

        return dateFormatter.string(from: self)
    }

    var yesterdayFmt: String {
        let fmt = "Вчера в " + self.time

        return fmt
    }

    var fullFmt: String {
        let fmt = self.dayMonthYear + " в " + self.time

        return fmt
    }
}
