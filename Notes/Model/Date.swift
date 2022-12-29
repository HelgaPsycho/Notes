//
//  Date.swift
//  Notes
//
//  Created by Ольга Егорова on 22.12.2022.
//

import Foundation
extension Date {
    var dayText: String {
        if Locale.current.calendar.isDateInToday(self) {
            let timeText = formatted(date: .omitted, time: .shortened)
            let timeFormat = NSLocalizedString("Today at %@", comment: "Today and time format string")
            return String(format: timeFormat, timeText)
        } else {
            return formatted(.dateTime.month().day().weekday())
        }
    }
}
