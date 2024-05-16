//
//  RegistrationView.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel: RegistrationViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                SmallButton(text: Texts.Registration.changeServer.rawValue) {
                    viewModel.changeServer()
                }
                Spacer()
            }
            Spacer()
            CustomizedTextField(
                placeholder: Texts.Registration.email.rawValue,
                text: $viewModel.email
            )
            .padding(.bottom, 10)
            CustomizedTextField(
                placeholder: Texts.Registration.password.rawValue,
                text: $viewModel.password,
                isSecure: true
            )
            Text(Texts.Registration.passwordHelp.rawValue)
                .font(.system(size: 10))
                .foregroundStyle(Color(.grayAccent))
            SmallButton(text: Texts.ButtonsTexts.forgotPassword.rawValue) {
                viewModel.forgotPassword()
            }
            .padding(.top, 10)
            Spacer()
            CustomizedButton(
                text: Texts.ButtonsTexts.login.rawValue,
                isLoading: $viewModel.isLoading
            ) {
                viewModel.login()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .standartBackground()
        .withClosingKeyboard()
        .alertWrapper(alertItem: $viewModel.alert)
    }
}
