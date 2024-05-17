//
//  EnterDBModel.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 17.05.2024.
//

import Foundation

struct EnterDBModel: Equatable {
    let id: UUID
    let employerId: UUID
    let time: Date
    let isOn: Bool
}
