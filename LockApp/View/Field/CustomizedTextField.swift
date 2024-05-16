//
//  CustomizedTextField.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import SwiftUI

struct CustomizedTextField: View {
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    
    @State var isFieldEditing = false
    
    @FocusState var focus: Bool?
    
    init(placeholder: String, text: Binding<String>, isSecure: Bool = false) {
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.isFieldEditing = isFieldEditing
    }
    
    var body: some View {
        field
            .textInputAutocapitalization(.never)
            .font(.system(size: 20))
            .padding(12)
            .padding(.horizontal, 8)
            .overlay {
                Capsule()
                    .stroke(lineWidth: 2)
                    .fill(borderColor)
                    .shadow(color: Color(.shadow), radius: 1)
            }
    }
    
    var borderColor: Color {
        if isFieldEditing {
            return Color(.accent)
        } else {
            return Color(.grayAccent)
        }
    }
    
    @ViewBuilder
    var field: some View {
        if isSecure {
            SecureField(placeholder, text: $text)
                .focused($focus, equals: true)
                .onChange(of: focus) { _, newValue in
                    isFieldEditing = newValue ?? false
                }
        } else {
            TextField(placeholder, text: $text) { isEditing in
                isFieldEditing = isEditing
            }
        }
    }
}

#Preview {
    @State var text = ""
    return CustomizedTextField(placeholder: "Enter server", text: $text, isSecure: true)
}
