//
//  SettingsView.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 17.05.2024.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            info
            Spacer()
            CustomizedButton(text: Texts.ButtonsTexts.changePassword.rawValue) {
                viewModel.changePassword()
            }
            CustomizedButton(text: Texts.ButtonsTexts.logout.rawValue, accentColor: Color(.bad)) {
                viewModel.logout()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .standartBackground()
        .alertWrapper(alertItem: $viewModel.alert)
    }
    
    @ViewBuilder
    var info: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("\(viewModel.name) \(viewModel.surname)")
                .font(.system(size: 30, weight: .heavy, design: .rounded))
                .foregroundStyle(Color(.shadow))
            HStack {
                Circle()
                    .fill(Color(.accent))
                    .frame(width: 10)
                Text(viewModel.department)
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundStyle(Color(.grayAccent))
            }
            HStack {
                Circle()
                    .fill(Color(.accent))
                    .frame(width: 10)
                Text(viewModel.email)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color(.grayAccent))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 30)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 8)
                .fill(Color(.accent))
        }
    }
}

#Preview {
    SettingsView(viewModel: .init(user: .init(
        id: nil,
        isAdmin: true,
        name: "Anatolii",
        surname: "Khramchenko",
        department: "iOS",
        email: "anatolii@gmail.com"
    )))
}
