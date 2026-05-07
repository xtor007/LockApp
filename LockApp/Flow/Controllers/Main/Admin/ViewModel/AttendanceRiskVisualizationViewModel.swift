//
//  AttendanceRiskVisualizationViewModel.swift
//  LockApp
//
//  Created by OpenAI Codex on 07.05.2026.
//

import Foundation

final class AttendanceRiskVisualizationViewModel: ObservableObject {
    enum RiskBucket: String, CaseIterable, Identifiable {
        case stableNormal
        case green
        case blue
        case red

        var id: String {
            rawValue
        }
    }

    struct ChartPoint: Identifiable {
        let day: Date
        let score: Double
        let bucket: RiskBucket

        var id: String {
            AttendanceRiskFormatter.apiDay(day)
        }
    }

    struct HistogramItem: Identifiable {
        let bucket: RiskBucket
        let count: Int

        var id: String {
            bucket.id
        }
    }

    @Published private(set) var startDate: Date
    @Published private(set) var endDate: Date

    let user: AttendanceRiskUserSummary
    let maximumDate: Date

    private let calendar: Calendar
    private let datedResults: [DatedResult]

    init(
        user: AttendanceRiskUserSummary,
        results: [AttendanceUserResult],
        calendar: Calendar = .current,
        today: Date = Date()
    ) {
        self.user = user
        self.calendar = calendar
        self.maximumDate = calendar.startOfDay(for: today)
        self.endDate = self.maximumDate
        self.startDate = calendar.date(byAdding: .day, value: -30, to: self.maximumDate) ?? self.maximumDate
        self.datedResults = results.compactMap { result in
            guard let day = AttendanceRiskFormatter.date(fromApiDay: result.day) else {
                return nil
            }
            return DatedResult(day: calendar.startOfDay(for: day), result: result)
        }
        .sorted(by: { $0.day < $1.day })
    }

    var chartPoints: [ChartPoint] {
        filteredResults.compactMap { item in
            guard let bucket = bucket(for: item.result),
                  let score = chartScore(for: item.result, bucket: bucket) else {
                return nil
            }

            return ChartPoint(
                day: item.day,
                score: score * 100,
                bucket: bucket
            )
        }
    }

    var histogramItems: [HistogramItem] {
        let buckets = filteredResults.compactMap { bucket(for: $0.result) }
        return RiskBucket.allCases.map { bucket in
            HistogramItem(
                bucket: bucket,
                count: buckets.filter({ $0 == bucket }).count
            )
        }
    }

    var filteredResultsCount: Int {
        filteredResults.count
    }

    func updateStartDate(_ date: Date) {
        let normalizedDate = normalized(date)
        startDate = normalizedDate
        if startDate > endDate {
            endDate = startDate
        }
    }

    func updateEndDate(_ date: Date) {
        let normalizedDate = min(normalized(date), maximumDate)
        endDate = normalizedDate
        if endDate < startDate {
            startDate = endDate
        }
    }
}

private extension AttendanceRiskVisualizationViewModel {
    struct DatedResult {
        let day: Date
        let result: AttendanceUserResult
    }

    var filteredResults: [DatedResult] {
        datedResults.filter { item in
            item.day >= startDate && item.day <= endDate
        }
    }

    func normalized(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    func bucket(for result: AttendanceUserResult) -> RiskBucket? {
        if result.isStableNormal {
            return .stableNormal
        }

        switch result.riskZone?.lowercased() {
        case "green":
            return .green
        case "yellow", "blue":
            return .blue
        case "red":
            return .red
        default:
            return nil
        }
    }

    func chartScore(for result: AttendanceUserResult, bucket: RiskBucket) -> Double? {
        if let riskScore = result.riskScore {
            return min(max(riskScore, 0), 1)
        }

        if bucket == .stableNormal {
            return 0
        }

        return nil
    }
}
