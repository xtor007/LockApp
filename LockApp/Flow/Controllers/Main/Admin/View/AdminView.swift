//
//  AdminView.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 18.05.2024.
//

import SwiftUI

struct AdminView: View {
    @StateObject var viewModel: AdminViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                header
                sorting
                if viewModel.recordsToShow.isEmpty {
                    Spacer()
                    Text(Texts.Logs.noData.rawValue)
                        .font(.system(size: 16))
                        .foregroundStyle(Color(.grayAccent))
                    Spacer()
                } else {
                    table
                }
            }
            addButton
        }
        .padding(.bottom, 1)
        .padding(.horizontal, 16)
        .standartBackground()
        .alertWrapper(alertItem: $viewModel.alert)
        .onAppear {
            viewModel.didAppear()
        }
    }
    
    @ViewBuilder
    var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(Texts.Attendance.date.rawValue)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color(.shadow))
                    DatePicker("", selection: $viewModel.selectedDate, displayedComponents: .date)
                        .labelsHidden()
                }
                Spacer()
                UpdaterView(isLoading: $viewModel.isLoading) {
                    viewModel.updateAttendanceRisk()
                }
            }
            HStack {
                Text(viewModel.selectedDateTitle)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color(.shadow))
                Spacer()
                Text("\(viewModel.recordsToShow.count) \(Texts.Attendance.people.rawValue)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color(.grayAccent))
            }
        }
    }
    
    @ViewBuilder
    var sorting: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(Texts.Attendance.sort.rawValue)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(.shadow))
            Selector(items: viewModel.sortModes, selectedItem: $viewModel.sortMode)
        }
    }
    
    @ViewBuilder
    var table: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Divider()
                ForEach(viewModel.recordsToShow) { record in
                    Button(action: {
                        viewModel.openStatistics(for: record)
                    }, label: {
                        cell(record)
                    })
                    .buttonStyle(.plain)
                    Divider()
                }
            }
        }
    }
    
    @ViewBuilder
    func cell(_ record: AttendanceRiskDayRecord) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(record.user.fullName)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color(.shadow))
                    if let department = record.user.department, !department.isEmpty {
                        Text(department)
                            .font(.system(size: 14))
                            .foregroundStyle(Color(.grayAccent))
                    }
                }
                Spacer()
                if let cluster = record.cluster, !cluster.isEmpty {
                    Text(cluster)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color(.accent))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background {
                            Capsule()
                                .fill(Color(.accent).opacity(0.15))
                        }
                }
            }
            HStack(spacing: 12) {
                metric(
                    title: Texts.Attendance.workDelta.rawValue,
                    value: AttendanceRiskFormatter.workDelta(record.workDeltaMinutes),
                    accentColor: deltaColor(record.workDeltaMinutes)
                )
                metric(
                    title: Texts.Attendance.justification.rawValue,
                    value: AttendanceRiskFormatter.percent(record.etaNN),
                    accentColor: record.etaNN == nil ? Color(.grayAccent) : Color(.shadow)
                )
                metric(
                    title: Texts.Attendance.risk.rawValue,
                    value: AttendanceRiskFormatter.percent(record.riskScore),
                    accentColor: riskColor(record.riskZone)
                )
            }
        }
        .padding(.vertical, 12)
    }
    
    @ViewBuilder
    func metric(title: String, value: String, accentColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color(.grayAccent))
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(accentColor)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    var addButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    viewModel.openAddNewEmployer()
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .foregroundStyle(Color(.accent))
                        .background {
                            Circle()
                                .fill(Color(.background))
                        }
                })
            }
        }
        .padding(.vertical, 20)
    }
    
    private func riskColor(_ riskZone: String?) -> Color {
        switch riskZone {
        case "green":
            return Color(.good)
        case "yellow":
            return Color(.accent)
        case "red":
            return Color(.bad)
        default:
            return Color(.grayAccent)
        }
    }
    
    private func deltaColor(_ workDeltaMinutes: Int?) -> Color {
        guard let workDeltaMinutes else { return Color(.grayAccent) }
        if workDeltaMinutes < 0 {
            return Color(.bad)
        }
        if workDeltaMinutes > 0 {
            return Color(.good)
        }
        return Color(.shadow)
    }
}

#Preview {
    AdminView(viewModel: .init())
}
