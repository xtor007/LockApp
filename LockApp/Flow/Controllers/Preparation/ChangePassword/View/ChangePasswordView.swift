//
//  ChangePasswordView.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import SwiftUI

struct ChangePasswordView: View {
    @StateObject var viewModel: ChangePasswordViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            updater
            Spacer()
            fields
            Spacer()
            buttons
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .alertWrapper(alertItem: $viewModel.alert)
        .standartBackground()
        .withClosingKeyboard()
    }
    
    @ViewBuilder
    var fields: some View {
        switch viewModel.state {
        case .email:
            CustomizedTextField(placeholder: Texts.Registration.email.rawValue, text: $viewModel.email)
        case .code:
            CustomizedTextField(placeholder: Texts.Registration.code.rawValue, text: $viewModel.code)
        case .password:
            CustomizedTextField(placeholder: Texts.Registration.password.rawValue, text: $viewModel.password, isSecure: true)
            CustomizedTextField(placeholder: Texts.Registration.confirmPassword.rawValue, text: $viewModel.confirmPassword, isSecure: true)
        }
    }
    
    @ViewBuilder
    var buttons: some View {
        HStack(spacing: 10) {
            CustomizedButton(
                text: Texts.ButtonsTexts.prev.rawValue,
                isAvaliable: $viewModel.isPrevButtonAvailiable
            ) {
                withAnimation {
                    viewModel.prev()
                }
            }
            CustomizedButton(
                text: viewModel.nextButtonText,
                isLoading: $viewModel.isLoading,
                isAvaliable: $viewModel.isNextButtonAvailiable
            ) {
                withAnimation {
                    viewModel.next()
                }
            }
        }
    }
    
    @ViewBuilder
    var updater: some View {
        if viewModel.isResendOnScreen {
            HStack {
                Spacer()
                UpdaterView(isLoading: $viewModel.isResendCode) {
                    viewModel.resendCode()
                }
            }
        } else {
            VStack {}
                .frame(height: 35)
        }
    }
}

#Preview {
    ChangePasswordView(viewModel: ChangePasswordViewModel{})
}
