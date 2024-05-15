//
//  CustomizedButton.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import SwiftUI

struct CustomizedButton: View {
    let text: String
    @Binding var isLoading: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            guard !isLoading else { return }
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            onTap()
        }, label: {
            HStack {
                Spacer()
                if isLoading {
                    ActivityIndicator(
                        mainColor: Color(.background),
                        backgroundColor: Color(.accent)
                    )
                    .frame(height: 25)
                } else {
                    Text(text)
                        .font(.system(size: 25, weight: .bold))
                        .foregroundStyle(Color(.background))
                }
                Spacer()
            }
            .frame(height: 60)
            .background {
                Capsule()
                    .fill(Color(.accent))
                    .shadow(color: Color(.shadow), radius: 5)
            }
        })
    }
}

#Preview {
    @State var isLoading = true
    return CustomizedButton(text: "Button", isLoading: $isLoading) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
        }
    }
}
