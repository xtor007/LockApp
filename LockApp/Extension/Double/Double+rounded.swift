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
    
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
