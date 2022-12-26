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
            return NSLocalizedString("Сегодня", comment: "Today format string")
        } else {
            return formatted(.dateTime.month().day().weekday())
        }
    }
}
