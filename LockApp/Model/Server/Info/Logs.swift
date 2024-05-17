//
//  Logs.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 17.05.2024.
//

import Foundation

struct Logs: Codable {
    let logs: [EnterModel]
}

struct EnterModel: Codable {
    let isOn: Bool
    let time: Date
}
