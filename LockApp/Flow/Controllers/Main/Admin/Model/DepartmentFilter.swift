//
//  DepartmentFilter.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 17.05.2024.
//

import Foundation

enum DepartmentFilter: Hashable, Identifiable {
    case all, other(String)

    var id: String {
        switch self {
        case .all:
            return "all"
        case .other(let string):
            return "department-\(string.lowercased())"
        }
    }
    
    var text: String {
        switch self {
        case .all:
            Texts.Attendance.allDepartments.rawValue
        case .other(let string):
            string
        }
    }
}
