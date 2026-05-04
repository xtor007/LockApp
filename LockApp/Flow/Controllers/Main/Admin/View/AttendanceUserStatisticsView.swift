//
//  AttendanceUserStatisticsView.swift
//  LockApp
//
//  Created by OpenAI Codex on 30.04.2026.
//

import SwiftUI

struct AttendanceUserStatisticsView: View {
    @StateObject var viewModel: AttendanceUserStatisticsViewModel
    @State private var correctionTarget: AttendanceCorrectionTarget?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            if viewModel.resultsToShow.isEmpty {
                Spacer()
                if viewModel.isLoading {
                    ActivityIndicator(mainColor: Color(.accent), backgroundColor: Color(.background))
                        .frame(height: 40)
                } else {
                    Text(Texts.Logs.noData.rawValue)
                        .font(.system(size: 16))
                        .foregroundStyle(Color(.grayAccent))
                }
                Spacer()
            } else {
                content
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .standartBackground()
        .alertWrapper(alertItem: $viewModel.alert)
        .sheet(item: $correctionTarget) { target in
            AttendanceCorrectionSheet(viewModel: viewModel, result: target.result)
                .presentationDetents([.medium])
        }
    }
    
    @ViewBuilder
    var header: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.user.fullName)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color(.shadow))
                if let department = viewModel.user.department, !department.isEmpty {
                    Text(department)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color(.grayAccent))
                }
                Text(Texts.Attendance.userStatistics.rawValue)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color(.accent))
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 8) {
                if viewModel.canOpenUserManagement {
                    SmallButton(text: Texts.Attendance.manageUser.rawValue) {
                        viewModel.openUserManagement()
                    }
                }
                if viewModel.isLoading {
                    ActivityIndicator(mainColor: Color(.accent), backgroundColor: Color(.background))
                        .frame(height: 20)
                }
            }
        }
    }
    
    @ViewBuilder
    var content: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(viewModel.resultsToShow, id: \.day) { result in
                    cell(result)
                }
            }
        }
    }
    
    @ViewBuilder
    func cell(_ result: AttendanceUserResult) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(AttendanceRiskFormatter.displayDay(result.day))
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color(.shadow))
                    if let clusterName = result.clusterName, !clusterName.isEmpty {
                        Text("\(Texts.Attendance.cluster.rawValue): \(clusterName)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color(.accent))
                    }
                }
                Spacer()
                metric(
                    title: Texts.Attendance.risk.rawValue,
                    value: AttendanceRiskFormatter.percent(result.riskScore),
                    accentColor: riskColor(result.riskZone)
                )
                .frame(width: 80, alignment: .trailing)
            }
            HStack(spacing: 12) {
                metric(
                    title: Texts.Attendance.workDelta.rawValue,
                    value: AttendanceRiskFormatter.workDelta(result.workDeltaMinutes),
                    accentColor: deltaColor(result.workDeltaMinutes)
                )
                metric(
                    title: Texts.Attendance.justification.rawValue,
                    value: AttendanceRiskFormatter.percent(result.etaNN),
                    accentColor: result.etaNN == nil ? Color(.grayAccent) : Color(.shadow)
                )
                metric(
                    title: Texts.Attendance.airAlert.rawValue,
                    value: AttendanceRiskFormatter.duration(result.detailsJson.airAlertMinutes),
                    accentColor: Color(.shadow)
                )
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(Texts.Attendance.externalFactors.rawValue)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color(.shadow))
                factorRow(Texts.Attendance.traffic.rawValue, AttendanceRiskFormatter.scoreOutOfTen(result.detailsJson.trafficScore))
                factorRow(Texts.Attendance.power.rawValue, AttendanceRiskFormatter.scoreOutOfTen(result.detailsJson.powerScore))
                factorRow(Texts.Attendance.weather.rawValue, AttendanceRiskFormatter.scoreOutOfTen(result.detailsJson.weatherScore))
                if let weatherContext = AttendanceRiskFormatter.weatherContext(result.detailsJson.weatherContext) {
                    factorRow(Texts.Attendance.weatherContext.rawValue, weatherContext)
                }
            }
            Button(action: {
                correctionTarget = AttendanceCorrectionTarget(result: result)
            }, label: {
                Text(Texts.Attendance.correctJustification.rawValue)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color(.accent))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background {
                        Capsule()
                            .stroke(lineWidth: 1)
                            .fill(Color(.accent))
                            .shadow(color: Color(.shadow), radius: 5)
                    }
            })
            .accessibilityLabel(Texts.Attendance.correctJustification.rawValue)
            .accessibilityIdentifier("attendance-correct-\(result.day)")
        }
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
    func factorRow(_ title: String, _ value: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color(.grayAccent))
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(.shadow))
                .multilineTextAlignment(.trailing)
        }
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

private struct AttendanceCorrectionTarget: Identifiable {
    let result: AttendanceUserResult
    
    var id: String {
        result.day
    }
}

private struct AttendanceCorrectionSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: AttendanceUserStatisticsViewModel
    
    let result: AttendanceUserResult
    
    @State private var percentText: String
    @State private var validationText: String?
    
    init(viewModel: AttendanceUserStatisticsViewModel, result: AttendanceUserResult) {
        self.viewModel = viewModel
        self.result = result
        _percentText = State(initialValue: AttendanceRiskFormatter.percentInput(result.etaNN))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(Texts.Attendance.correctJustification.rawValue)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color(.shadow))
                Spacer()
                Button(Texts.ButtonsTexts.cancel.rawValue) {
                    dismiss()
                }
                .foregroundStyle(Color(.accent))
            }
            Text(AttendanceRiskFormatter.displayDay(result.day))
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color(.grayAccent))
            CustomizedTextField(
                placeholder: Texts.Attendance.justificationPercent.rawValue,
                text: $percentText
            )
            Text(Texts.Attendance.correctionHint.rawValue)
                .font(.system(size: 14))
                .foregroundStyle(Color(.grayAccent))
            if let validationText {
                Text(validationText)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color(.bad))
            }
            Spacer()
            CustomizedButton(text: Texts.ButtonsTexts.confirm.rawValue, isLoading: $viewModel.isSubmittingCorrection) {
                submit()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .standartBackground()
        .withClosingKeyboard()
    }
    
    private func submit() {
        guard let etaValue = AttendanceRiskFormatter.etaValue(fromPercentInput: percentText) else {
            validationText = Texts.Attendance.invalidCorrectionPercent.rawValue
            return
        }
        
        validationText = nil
        viewModel.submitCorrection(for: result, etaValue: etaValue) {
            dismiss()
        }
    }
}
