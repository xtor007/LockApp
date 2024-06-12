//
//  LogsView.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 17.05.2024.
//

import SwiftUI

struct LogsView: View {
    @StateObject var viewModel: LogsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(viewModel.name) \(viewModel.surname)")
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .foregroundStyle(.shadow)
            Text("\(Texts.Main.average.rawValue) \(viewModel.average.toTwoDecimalPlaces())")
                .font(.system(size: 20, design: .rounded))
                .foregroundStyle(.shadow)
            content
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .standartBackground()
        .alertWrapper(alertItem: $viewModel.alert)
    }
    
    @ViewBuilder
    var content: some View {
        if let logs = viewModel.logs, !logs.isEmpty {
            table(logs: logs)
        } else {
            Spacer()
            HStack {
                Spacer()
                if viewModel.isLoading {
                    ActivityIndicator(mainColor: Color(.accent), backgroundColor: Color(.background))
                        .frame(width: 40)
                } else {
                    Text(Texts.Logs.noData.rawValue)
                        .font(.system(size: 20, design: .rounded))
                        .foregroundStyle(.grayAccent)
                }
                Spacer()
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func table(logs: [EnterDBModel]) -> some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Divider()
                ForEach(0..<logs.count, id: \.self) { index in
                    cell(logs[index])
                    Divider()
                }
            }
        }
    }
    
    @ViewBuilder
    func cell(_ enter: EnterDBModel) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(enter.time.formattedDayMonth())
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.shadow)
                Text(enter.time.formattedTime())
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.grayAccent)
            }
            Spacer()
            Circle()
                .fill(Color(enter.isOn ? .good : .bad))
                .frame(width: 10)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    LogsView(viewModel: LogsViewModel(
        average: 8.0,
        user: .init(
            id: nil, 
            isAdmin: true, 
            name: "Anatolii",
            surname: "Khramchenko",
            department: "head",
            email: "",
            hasCard: false,
            hasFinger: false
        ),
        logs: [
            .init(id: UUID(), employerId: UUID(), time: .now, isOn: true),
            .init(id: UUID(), employerId: UUID(), time: .now, isOn: false)
        ]
    ))
}
