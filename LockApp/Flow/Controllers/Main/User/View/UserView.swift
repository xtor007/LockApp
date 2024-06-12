//
//  UserView.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 31.05.2024.
//

import SwiftUI

struct UserView: View {
    @StateObject var viewModel: UserViewModel
    
    var body: some View {
        VStack {
            Text("\(viewModel.user.name ?? "") \(viewModel.user.surname ?? "")")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color(.shadow))
            Text(viewModel.user.department ?? "")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color(.grayAccent))
                .padding(.top, 4)
            Spacer()
            identifierField(text: Texts.User.card.rawValue, isAdded: viewModel.user.hasCard ?? false)
                .padding(.bottom, 16)
            identifierField(text: Texts.User.finger.rawValue, isAdded: viewModel.user.hasFinger ?? false)
                .padding(.bottom, 16)
            CustomizedButton(text: Texts.Main.logs.rawValue) {
                viewModel.showLogs()
            }
                .padding(.bottom, 16)
            CustomizedButton(
                text: Texts.ButtonsTexts.delete.rawValue,
                isLoading: $viewModel.isLoadingDelete,
                accentColor: .bad
            ) {
                viewModel.delete()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .standartBackground()
        .alertWrapper(alertItem: $viewModel.alert)
    }
    
    @ViewBuilder
    func identifierField(text: String, isAdded: Bool) -> some View {
        HStack {
            Text(text)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color(isAdded ? .good : .shadow))
            Spacer()
            if isAdded {
                SmallButton(text: Texts.ButtonsTexts.delete.rawValue, accentColor: .bad) {
                    ()
                }
            } else {
                SmallButton(text: Texts.ButtonsTexts.add.rawValue) {
                    ()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background {
            Capsule()
                .stroke(lineWidth: 2)
                .fill(Color(isAdded ? .good : .shadow))
        }
    }
}

#Preview {
    UserView(viewModel: .init(user: .init(id: nil, isAdmin: true, name: "Anatolii", surname: "Khramchenko", department: "iOS", email: "test@gmail.com", hasCard: true, hasFinger: false), average: 0.0))
}
