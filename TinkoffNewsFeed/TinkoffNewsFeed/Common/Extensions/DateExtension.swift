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

    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"

        return dateFormatter.string(from: self)
    }

    var dayMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"

        return dateFormatter.string(from: self)
    }

    var dayMonthYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"

        return dateFormatter.string(from: self)
    }

    // MARK: - Bool

    var calendar: Calendar {
        return Calendar.current
    }

    var isInToday: Bool {
        return self.calendar.isDateInToday(self)
    }

    var isInThisMonth: Bool {
        let today = Date()
        let thisMonth = self.calendar.component(.month, from: today)
        let dateMonth = self.calendar.component(.month, from: self)

        return thisMonth == dateMonth && self.isInThisYear
    }

    var isInThisYear: Bool {
        let today = Date()
        let thisYear = self.calendar.component(.year, from: today)
        let dateYear = self.calendar.component(.year, from: self)


        return thisYear == dateYear
    }
}
