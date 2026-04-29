//
//  AttendanceMLPFeedback.swift
//  LockApp
//
//  Created by OpenAI Codex on 30.04.2026.
//

import Foundation

struct AttendanceMLPFeedbackRequest: Encodable {
    let userId: UUID
    let day: String
    let etaNn: Double
}

struct AttendanceMLPFeedbackResponse: Codable {
    let feedbackSampleId: UUID
    let pendingFeedbackCount: Int
    let retrainingTriggered: Bool
    let retrainedModelVersion: String?
    let retrainingError: String?
    let result: AttendanceUserResult
}
