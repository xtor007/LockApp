//
//  AttendanceRiskDayResponse.swift
//  LockApp
//
//  Created by OpenAI Codex on 30.04.2026.
//

import Foundation

struct AttendanceRiskDayResponse: Codable {
    let day: String
    let items: [AttendanceRiskDayRecord]
}

struct AttendanceRiskDayRecord: Codable, Equatable, Identifiable {
    let user: AttendanceRiskUserSummary
    let workDeltaMinutes: Int?
    let cluster: String?
    let etaNN: Double?
    let riskScore: Double?
    let riskZone: String?
    let status: String
    let clusteringStatus: String?
    let mlpStatus: String?
    
    var id: UUID {
        user.id
    }
}

struct AttendanceRiskUserSummary: Codable, Equatable, Identifiable {
    let id: UUID
    let name: String?
    let surname: String?
    let email: String?
    let department: String?
    
    var fullName: String {
        let parts = [name, surname]
            .compactMap({ $0?.trimmingCharacters(in: .whitespacesAndNewlines) })
            .filter({ !$0.isEmpty })
        return parts.isEmpty ? email ?? id.uuidString : parts.joined(separator: " ")
    }
    
    var alphabeticalKey: String {
        let surname = self.surname?.lowercased() ?? ""
        let name = self.name?.lowercased() ?? ""
        let email = self.email?.lowercased() ?? ""
        return "\(surname) \(name) \(email)"
    }
}
