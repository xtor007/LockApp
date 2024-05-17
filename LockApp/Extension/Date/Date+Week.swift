//
//  Date+Week.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 17.05.2024.
//

import Foundation

extension Date {
    func isSameDay(_ date: Date, using calendar: Calendar = Calendar.current) -> Bool {
        calendar.isDate(date, inSameDayAs: self)
    }
    
    func startOfWeek(using calendar: Calendar = Calendar.current) -> Date {
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        return calendar.date(from: components) ?? .distantPast
    }
    
    func endOfWeek(using calendar: Calendar = Calendar.current) -> Date {
        let startOfWeek = self.startOfWeek(using: calendar)
        var components = DateComponents()
        components.day = 6
        components.hour = 23
        components.minute = 59
        components.second = 59
        return calendar.date(byAdding: components, to: startOfWeek) ?? .distantFuture
    }
    
    func weekForward(using calendar: Calendar = Calendar.current) -> Date? {
        guard self < .now else { return nil }
        var components = DateComponents()
        components.day = 7
        return calendar.date(byAdding: components, to: self)
    }
    
    func weekBack(using calendar: Calendar = Calendar.current) -> Date? {
        var components = DateComponents()
        components.day = -7
        return calendar.date(byAdding: components, to: self)
    }
    
    func date(addings: Int, using calendar: Calendar = Calendar.current) -> Date {
        var components = DateComponents()
        components.day = addings
        return calendar.date(byAdding: components, to: self) ?? .distantFuture
    }
    
    func percentOfDayPassed(using calendar: Calendar = Calendar.current) -> Double {
        let currentComponents = calendar.dateComponents([.hour, .minute, .second], from: self)
        let totalSecondsInDay = 24 * 60 * 60
        let secondsPassed = currentComponents.hour! * 3600 + currentComponents.minute! * 60 + currentComponents.second!
        let percentOfDayPassed = Double(secondsPassed) / Double(totalSecondsInDay)
        return percentOfDayPassed
    }
}
