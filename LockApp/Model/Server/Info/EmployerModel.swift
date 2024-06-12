//
//  EmployerModel.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import Foundation

struct EmployerModel: Codable, Equatable {
    let id: UUID?
    let isAdmin: Bool
    let name: String?
    let surname: String?
    let department: String?
    let email: String?
    let hasCard: Bool?
    let hasFinger: Bool?
}
