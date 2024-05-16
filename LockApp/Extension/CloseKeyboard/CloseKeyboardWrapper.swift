//
//  CloseKeyboardWrapper.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import SwiftUI

struct CloseKeyboardWrapper: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
}

extension View {
    func withClosingKeyboard() -> some View {
        self.modifier(CloseKeyboardWrapper())
    }
}
