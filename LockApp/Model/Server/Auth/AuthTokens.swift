//
//  AuthTokens.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import Foundation

struct AuthTokens: Codable {
    let auth: String
    let refresh: String
    let expDate: Date
}
