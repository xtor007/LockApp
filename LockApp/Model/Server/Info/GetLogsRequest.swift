//
//  GetLogsRequest.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 17.05.2024.
//

import Foundation

struct GetLogsRequest: Codable {
    let valid: Bool
    let id: UUID?
    let afterDate: Date?
}
