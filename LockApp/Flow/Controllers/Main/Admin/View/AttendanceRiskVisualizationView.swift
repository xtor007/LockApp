//
//  AttendanceRiskVisualizationView.swift
//  LockApp
//
//  Created by OpenAI Codex on 07.05.2026.
//

import Charts
import SwiftUI

struct AttendanceRiskVisualizationView: View {
    @StateObject var viewModel: AttendanceRiskVisualizationViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                header
                dateRangeCard
                riskScoreChartCard
                histogramCard
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .standartBackground()
    }

    @ViewBuilder
    var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.user.fullName)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color(.shadow))
            if let department = viewModel.user.department, !department.isEmpty {
                Text(department)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color(.grayAccent))
            }
            Text(Texts.Attendance.visualization.rawValue)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color(.accent))
        }
    }

    @ViewBuilder
    var dateRangeCard: some View {
        card {
            VStack(alignment: .leading, spacing: 12) {
                Text(Texts.Attendance.date.rawValue)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color(.shadow))
                DatePicker(
                    Texts.Attendance.startDate.rawValue,
                    selection: startDateBinding,
                    in: ...viewModel.endDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .tint(Color(.accent))
                DatePicker(
                    Texts.Attendance.endDate.rawValue,
                    selection: endDateBinding,
                    in: viewModel.startDate...viewModel.maximumDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .tint(Color(.accent))
                Text("\(viewModel.filteredResultsCount) \(Texts.Attendance.selectedDays.rawValue)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color(.grayAccent))
            }
        }
    }

    @ViewBuilder
    var riskScoreChartCard: some View {
        card {
            VStack(alignment: .leading, spacing: 12) {
                Text(Texts.Attendance.scoreDynamics.rawValue)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color(.shadow))
                if viewModel.chartPoints.isEmpty {
                    emptyState
                } else {
                    Chart(viewModel.chartPoints) { point in
                        LineMark(
                            x: .value(Texts.Attendance.date.rawValue, point.day),
                            y: .value(Texts.Attendance.risk.rawValue, point.score)
                        )
                        .foregroundStyle(Color(.accent))
                        .interpolationMethod(.catmullRom)

                        PointMark(
                            x: .value(Texts.Attendance.date.rawValue, point.day),
                            y: .value(Texts.Attendance.risk.rawValue, point.score)
                        )
                        .foregroundStyle(color(for: point.bucket))
                    }
                    .chartYScale(domain: 0 ... 100)
                    .chartXAxis {
                        AxisMarks(values: .automatic(desiredCount: min(max(viewModel.chartPoints.count, 2), 6))) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel {
                                if let date = value.as(Date.self) {
                                    Text(axisDay(date))
                                        .font(.system(size: 11, weight: .medium))
                                }
                            }
                        }
                    }
                    .chartYAxis {
                        AxisMarks(values: [0, 25, 50, 75, 100]) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel {
                                if let score = value.as(Double.self) {
                                    Text("\(Int(score))%")
                                        .font(.system(size: 11, weight: .medium))
                                }
                            }
                        }
                    }
                    .frame(height: 240)

                    Text(Texts.Attendance.stableNormalRiskHint.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color(.grayAccent))
                }
            }
        }
    }

    @ViewBuilder
    var histogramCard: some View {
        card {
            VStack(alignment: .leading, spacing: 12) {
                Text(Texts.Attendance.riskHistogram.rawValue)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color(.shadow))
                if viewModel.histogramItems.allSatisfy({ $0.count == 0 }) {
                    emptyState
                } else {
                    Chart(viewModel.histogramItems) { item in
                        BarMark(
                            x: .value(Texts.Attendance.risk.rawValue, title(for: item.bucket)),
                            y: .value(Texts.Attendance.selectedDays.rawValue, item.count)
                        )
                        .foregroundStyle(color(for: item.bucket))
                        .annotation(position: .top) {
                            if item.count > 0 {
                                Text("\(item.count)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(Color(.shadow))
                            }
                        }
                    }
                    .chartXAxis {
                        AxisMarks { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel {
                                if let title = value.as(String.self) {
                                    Text(title)
                                        .font(.system(size: 11, weight: .medium))
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                    }
                    .frame(height: 240)
                    legend
                }
            }
        }
    }
}

private extension AttendanceRiskVisualizationView {
    var startDateBinding: Binding<Date> {
        Binding(
            get: { viewModel.startDate },
            set: { viewModel.updateStartDate($0) }
        )
    }

    var endDateBinding: Binding<Date> {
        Binding(
            get: { viewModel.endDate },
            set: { viewModel.updateEndDate($0) }
        )
    }

    @ViewBuilder
    var legend: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
            ForEach(AttendanceRiskVisualizationViewModel.RiskBucket.allCases) { bucket in
                HStack(spacing: 8) {
                    Circle()
                        .fill(color(for: bucket))
                        .frame(width: 10, height: 10)
                    Text(title(for: bucket))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color(.shadow))
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(.background))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(.grayAccent).opacity(0.25), lineWidth: 1)
                }
            }
        }
    }

    @ViewBuilder
    var emptyState: some View {
        Text(Texts.Logs.noData.rawValue)
            .font(.system(size: 16))
            .foregroundStyle(Color(.grayAccent))
            .frame(maxWidth: .infinity, minHeight: 160)
    }

    @ViewBuilder
    func card<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.background))
                    .shadow(color: Color(.shadow).opacity(0.1), radius: 8)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(.grayAccent).opacity(0.3), lineWidth: 1)
            }
    }

    func title(for bucket: AttendanceRiskVisualizationViewModel.RiskBucket) -> String {
        switch bucket {
        case .stableNormal:
            return Texts.Attendance.stableNormal.rawValue
        case .green:
            return Texts.Attendance.greenZone.rawValue
        case .blue:
            return Texts.Attendance.blueZone.rawValue
        case .red:
            return Texts.Attendance.redZone.rawValue
        }
    }

    func color(for bucket: AttendanceRiskVisualizationViewModel.RiskBucket) -> Color {
        switch bucket {
        case .stableNormal:
            return Color(.shadow)
        case .green:
            return Color(.good)
        case .blue:
            return Color(.accent)
        case .red:
            return Color(.bad)
        }
    }

    func axisDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd.MM"
        return formatter.string(from: date)
    }
}
