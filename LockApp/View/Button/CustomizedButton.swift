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
    @Binding var isAvaliable: Bool
    @State var accentColor: Color
    let onTap: () -> Void
    
    init(text: String, isLoading: Binding<Bool> = .constant(false), accentColor: Color = Color(.accent), isAvaliable: Binding<Bool> = .constant(true), onTap: @escaping () -> Void) {
        self.text = text
        self._isLoading = isLoading
        self._isAvaliable = isAvaliable
        self.accentColor = accentColor
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {
            guard !isLoading else { return }
            guard isAvaliable else { return }
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            onTap()
        }, label: {
            HStack {
                Spacer()
                if isLoading {
                    ActivityIndicator(
                        mainColor: Color(.background),
                        backgroundColor: accentColor
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
                    .fill(isAvaliable ? accentColor : Color(.grayAccent))
                    .shadow(color: Color(.shadow), radius: 5)
            }
        })
    }
}

#Preview {
    @State var isLoading = false
    return CustomizedButton(text: "Button", isLoading: $isLoading, isAvaliable: .constant(false)) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
        }
    }
}
