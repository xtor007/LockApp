//
//  OpenButton.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import SwiftUI

struct OpenButton: View {
    @Binding var state: OpenButtonState
    let onOpen: () -> Void
    
    private let size: CGFloat = 140
    
    var body: some View {
        Button(action: {
            guard state == .ready else { return }
            onOpen()
        }, label: {
            ZStack {
                Circle()
                    .stroke(lineWidth: size / 20)
                Circle()
                    .frame(width: size * 0.8, height: size * 0.8)
                if state == .ready {
                    Text(Texts.Main.open.rawValue)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color(.background))
                }
            }
            .foregroundStyle(color)
            .frame(width: size, height: size)
        })
    }
    
    var color: Color {
        switch state {
        case .ready:
            Color(.accent)
        case .opening:
            Color(.grayAccent)
        case .failed:
            Color(.bad)
        case .success:
            Color(.good)
        }
    }
}

#Preview {
    OpenButton(state: .constant(.success)) {}
}
