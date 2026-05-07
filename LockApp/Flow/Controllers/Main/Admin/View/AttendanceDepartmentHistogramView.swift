//
//  AttendanceDepartmentHistogramView.swift
//  LockApp
//
//  Created by OpenAI Codex on 07.05.2026.
//

import Charts
import SwiftUI

struct AttendanceDepartmentHistogramView: View {
    @StateObject var viewModel: AttendanceDepartmentHistogramViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                header
                filtersCard
                histogramCard
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .standartBackground()
        .alertWrapper(alertItem: $viewModel.alert)
    }

    @ViewBuilder
    var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(Texts.Attendance.departmentHistogram.rawValue)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color(.shadow))
            Text(Texts.Attendance.overview.rawValue)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color(.accent))
        }
    }

    @ViewBuilder
    var filtersCard: some View {
        card {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    Text(Texts.Attendance.date.rawValue)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color(.shadow))
                    Spacer()
                    UpdaterView(isLoading: isLoadingBinding) {
                        viewModel.refresh()
                    }
                }
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
                VStack(alignment: .leading, spacing: 8) {
                    Text(Texts.Attendance.department.rawValue)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color(.shadow))
                    departmentPicker
                }
                Text("\(viewModel.filteredRecordsCount) \(Texts.Attendance.records.rawValue)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color(.grayAccent))
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
                if viewModel.isLoading && viewModel.histogramItems.allSatisfy({ $0.count == 0 }) {
                    ActivityIndicator(mainColor: Color(.accent), backgroundColor: Color(.background))
                        .frame(maxWidth: .infinity, minHeight: 180)
                } else if viewModel.histogramItems.allSatisfy({ $0.count == 0 }) {
                    emptyState
                } else {
                    Chart(viewModel.histogramItems) { item in
                        BarMark(
                            x: .value(Texts.Attendance.risk.rawValue, title(for: item.bucket)),
                            y: .value(Texts.Attendance.records.rawValue, item.count)
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
                    .frame(height: 260)
                    legend
                }
            }
        }
    }
}

private extension AttendanceDepartmentHistogramView {
    var isLoadingBinding: Binding<Bool> {
        Binding(
            get: { viewModel.isLoading },
            set: { _ in }
        )
    }

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
    var departmentPicker: some View {
        Menu {
            ForEach(viewModel.departmentOptions) { department in
                Button(action: {
                    viewModel.selectDepartment(department)
                }, label: {
                    Text(department.text)
                })
            }
        } label: {
            HStack {
                Text(viewModel.selectedDepartment.text)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color(.shadow))
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .foregroundStyle(Color(.accent))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.background))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.grayAccent).opacity(0.3), lineWidth: 1)
            }
        }
    }

    @ViewBuilder
    var legend: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
            ForEach(AttendanceDepartmentHistogramViewModel.RiskBucket.allCases) { bucket in
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
            .frame(maxWidth: .infinity, minHeight: 180)
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

    func title(for bucket: AttendanceDepartmentHistogramViewModel.RiskBucket) -> String {
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

    func color(for bucket: AttendanceDepartmentHistogramViewModel.RiskBucket) -> Color {
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
}
