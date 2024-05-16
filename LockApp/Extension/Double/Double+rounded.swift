//
//  Double+rounded.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import Foundation

extension Double {
    func toTwoDecimalPlaces() -> String {
        return String(format: "%.2f", self)
    }
}
