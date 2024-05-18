//
//  AddView.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 18.05.2024.
//

import SwiftUI

struct AddView: View {
    @StateObject var viewModel: AddViewModel
    
    var body: some View {
        VStack {
            fields
            CustomizedButton(text: Texts.ButtonsTexts.add.rawValue, isLoading: $viewModel.isLoading) {
                viewModel.add()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .standartBackground()
        .alertWrapper(alertItem: $viewModel.alert)
        .withClosingKeyboard()
    }
    
    @ViewBuilder
    var fields: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                CustomizedTextField(placeholder: Texts.Add.name.rawValue, text: $viewModel.name)
                CustomizedTextField(placeholder: Texts.Add.surname.rawValue, text: $viewModel.surname)
                CustomizedTextField(placeholder: Texts.Add.email.rawValue, text: $viewModel.email)
                CustomizedTextField(placeholder: Texts.Add.departmrnt.rawValue, text: $viewModel.department)
                CheckmarkWithText(text: Texts.Add.isAdmin.rawValue, isChecked: $viewModel.isAdmin)
            }
            .padding(10)
        }
    }
}

#Preview {
    AddView(viewModel: .init(department: nil) {})
}
