//
//  AttendanceUserResultsResponse.swift
//  LockApp
//
//  Created by OpenAI Codex on 30.04.2026.
//

import Foundation

struct AttendanceUserResultsResponse: Codable {
    let results: [AttendanceUserResult]
}

struct AttendanceUserResult: Codable, Equatable {
    let id: UUID?
    let userId: UUID
    let day: String
    let status: String
    let observationId: UUID?
    let historyDaysUsed: Int
    let averageStartMinutes: Double?
    let stddevStartMinutes: Double?
    let stddevWorkedMinutes: Double?
    let workNormMinutes: Int
    let zS: Double?
    let zT: Double?
    let f: Double?
    let clusterName: String?
    let clusterScore: Double?
    let clusterWeight: Double?
    let clusterModelVersion: Int?
    let clusterDistance: Double?
    let clusteringStatus: String?
    let etaNN: Double?
    let mlpModelVersion: String?
    let mlpStatus: String?
    let riskScore: Double?
    let riskZone: String?
    let detailsJson: AttendanceAnalysisDetails
    let createdAt: Date?
    let updatedAt: Date?
    
    var workedMinutes: Int {
        detailsJson.sessionRanges.reduce(0, { $0 + $1.workedMinutes })
    }
    
    var workDeltaMinutes: Int {
        workedMinutes - workNormMinutes
    }

    var isStableNormal: Bool {
        status == "clustering_terminal_stable_normal" ||
            clusteringStatus == "stable_normal_terminal" ||
            clusterName?.caseInsensitiveCompare("Stable Normal") == .orderedSame
    }
}

struct AttendanceAnalysisDetails: Codable, Equatable {
    let workNormMinutes: Int
    let rawEventCount: Int
    let sessionStartsCount: Int
    let completedSessionsCount: Int
    let sessionRanges: [AttendanceAnalysisSessionRange]
    let anomalyReasons: [String]
    let note: String?
    let baselineWindowDays: Int?
    let historyDaysUsed: Int?
    let deficitHistoryDaysCount: Int?
    let averageStartMinutes: Double?
    let stddevStartMinutes: Double?
    let stddevWorkedMinutes: Double?
    let zS: Double?
    let zT: Double?
    let f: Double?
    let calculationNotes: [String]?
    let airAlertMinutes: Int?
    let trafficScore: Double?
    let powerScore: Double?
    let weatherScore: Double?
    let weatherContext: AttendanceWeatherContext?
    let externalContextNotes: [String]?
    let clusterName: String?
    let clusterScore: Double?
    let clusterWeight: Double?
    let clusterModelVersion: Int?
    let clusterDistance: Double?
    let clusteringStatus: String?
    let clusteringNotes: [String]?
}

struct AttendanceAnalysisSessionRange: Codable, Equatable {
    let start: Date
    let end: Date
    let workedMinutes: Int
}

struct AttendanceWeatherContext: Codable, Equatable {
    let weatherScore: Double
    let precipitation: Double?
    let isIcy: Bool
    let visibility: Double?
}
