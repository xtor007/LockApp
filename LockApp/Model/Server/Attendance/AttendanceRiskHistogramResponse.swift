//
//  AttendanceRiskHistogramResponse.swift
//  LockApp
//
//  Created by OpenAI Codex on 07.05.2026.
//

import Foundation

struct AttendanceRiskHistogramResponse: Codable {
    let startDay: String
    let endDay: String
    let department: String?
    let totalCount: Int
    let buckets: [AttendanceRiskHistogramBucketResponse]
}

struct AttendanceRiskHistogramBucketResponse: Codable, Equatable {
    let key: String
    let count: Int
}
