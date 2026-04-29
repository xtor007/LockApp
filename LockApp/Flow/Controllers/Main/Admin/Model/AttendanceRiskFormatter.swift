//
//  AttendanceRiskFormatter.swift
//  LockApp
//
//  Created by OpenAI Codex on 30.04.2026.
//

import Foundation

enum AttendanceRiskFormatter {
    private static let apiDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private static let displayDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    static func apiDay(_ date: Date) -> String {
        apiDayFormatter.string(from: date)
    }
    
    static func displayDay(_ date: Date) -> String {
        displayDayFormatter.string(from: date)
    }
    
    static func displayDay(_ day: String) -> String {
        guard let date = apiDayFormatter.date(from: day) else { return day }
        return displayDayFormatter.string(from: date)
    }
    
    static func percent(_ value: Double?) -> String {
        guard let value else { return Texts.Attendance.emptyValue.rawValue }
        let percentValue = Int((value * 100).rounded())
        return "\(percentValue)%"
    }
    
    static func percentInput(_ value: Double?) -> String {
        guard let value else { return "" }
        let percentValue = (value * 100).rounded(toPlaces: 1)
        if percentValue == floor(percentValue) {
            return String(Int(percentValue))
        }
        return String(percentValue)
    }
    
    static func workDelta(_ minutes: Int?) -> String {
        guard let minutes else { return Texts.Attendance.emptyValue.rawValue }
        return signedDuration(minutes)
    }
    
    static func duration(_ minutes: Int?) -> String {
        guard let minutes else { return Texts.Attendance.emptyValue.rawValue }
        return unsignedDuration(minutes)
    }
    
    static func weatherContext(_ weatherContext: AttendanceWeatherContext?) -> String? {
        guard let weatherContext else { return nil }
        var parts = [String]()
        parts.append(weatherContext.isIcy ? Texts.Attendance.icy.rawValue : Texts.Attendance.noIcing.rawValue)
        if let precipitation = weatherContext.precipitation {
            parts.append("\(Texts.Attendance.precipitation.rawValue) \(precipitation.rounded(toPlaces: 1))")
        }
        if let visibility = weatherContext.visibility {
            parts.append("\(Texts.Attendance.visibility.rawValue) \(visibility.rounded(toPlaces: 1))")
        }
        return parts.joined(separator: " · ")
    }
    
    static func etaValue(fromPercentInput text: String) -> Double? {
        let normalizedText = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        guard let percentValue = Double(normalizedText),
              (0 ... 100).contains(percentValue) else {
            return nil
        }
        
        return percentValue / 100
    }
    
    private static func signedDuration(_ minutes: Int) -> String {
        let sign = minutes > 0 ? "+" : minutes < 0 ? "-" : ""
        return sign + unsignedDuration(abs(minutes))
    }
    
    private static func unsignedDuration(_ minutes: Int) -> String {
        let hours = minutes / 60
        let remainder = minutes % 60
        if hours == 0 {
            return "\(remainder)m"
        }
        if remainder == 0 {
            return "\(hours)h"
        }
        return "\(hours)h \(remainder)m"
    }
}
