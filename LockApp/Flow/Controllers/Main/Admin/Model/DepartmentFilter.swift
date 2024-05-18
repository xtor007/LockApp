//
//  DepartmentFilter.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 17.05.2024.
//

import Foundation

enum DepartmentFilter: Equatable {
    case all, other(String)
    
    var text: String {
        switch self {
        case .all:
            Texts.Admin.all.rawValue
        case .other(let string):
            string
        }
    }
}
