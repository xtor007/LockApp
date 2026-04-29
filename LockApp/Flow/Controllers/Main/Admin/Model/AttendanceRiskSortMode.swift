//
//  AttendanceRiskSortMode.swift
//  LockApp
//
//  Created by OpenAI Codex on 30.04.2026.
//

import Foundation

enum AttendanceRiskSortMode: CaseIterable, SelectorItem {
    case worstRisk
    case bestRisk
    case alphabetically
    
    var name: String {
        switch self {
        case .worstRisk:
            Texts.Attendance.worst.rawValue
        case .bestRisk:
            Texts.Attendance.best.rawValue
        case .alphabetically:
            Texts.Attendance.alphabet.rawValue
        }
    }
}
