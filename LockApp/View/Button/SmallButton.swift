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
    
    var body: some View {
        Button(action: {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            onTap()
        }, label: {
            HStack {
                Text(text)
                    .font(.system(size: 16))
                    .foregroundStyle(Color(.accent))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
            }
            .background {
                Capsule()
                    .stroke(lineWidth: 1)
                    .fill(Color(.accent))
                    .shadow(color: Color(.shadow), radius: 5)
            }
        })
    }
}

#Preview {
    SmallButton(text: "123") {}
}
