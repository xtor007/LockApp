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
    
    @State var isFieldEditing = false
    
    var body: some View {
        TextField(placeholder, text: $text) { isEditing in
            isFieldEditing = isEditing
        }
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
}

#Preview {
    @State var text = ""
    return CustomizedTextField(placeholder: "Enter server", text: $text)
}
