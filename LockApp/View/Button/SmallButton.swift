//
//  SmallButton.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import SwiftUI

struct SmallButton: View {
    let text: String
    let onTap: () -> Void
    let accentColor: Color
    
    init(text: String, accentColor: Color = Color(.accent), onTap: @escaping () -> Void) {
        self.text = text
        self.onTap = onTap
        self.accentColor = accentColor
    }
    
    var body: some View {
        Button(action: {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            onTap()
        }, label: {
            HStack {
                Text(text)
                    .font(.system(size: 16))
                    .foregroundStyle(accentColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
            }
            .background {
                Capsule()
                    .stroke(lineWidth: 1)
                    .fill(accentColor)
                    .shadow(color: Color(.shadow), radius: 5)
            }
        })
    }
}

#Preview {
    SmallButton(text: "123") {}
}
