//
//  StandartBackgroundWrapper.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import SwiftUI

struct StandartBackgroundWrapper: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(.background).ignoresSafeArea())
    }
}

extension View {
    func standartBackground() -> some View {
        self.modifier(StandartBackgroundWrapper())
    }
}
