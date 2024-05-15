//
//  EnterServerView.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import SwiftUI

struct EnterServerView: View {
    @StateObject var viewModel: EnterServerViewModel
    
    var body: some View {
        VStack {
            Spacer()
            CustomizedTextField(
                placeholder: Texts.EnterServer.enterServer.rawValue,
                text: $viewModel.server
            )
            Spacer()
            CustomizedButton(
                text: Texts.ButtonsTexts.connect.rawValue,
                isLoading: $viewModel.isLoading
            ) {
                viewModel.validateServer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .standartBackground()
        .withClosingKeyboard()
        .alertWrapper(alertItem: $viewModel.alertItem)
    }
}

#Preview {
    EnterServerView(viewModel: EnterServerViewModel())
}
