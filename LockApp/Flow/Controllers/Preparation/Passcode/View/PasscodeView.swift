//
//  PasscodeView.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 24.05.2024.
//

import SwiftUI

struct PasscodeView: View {
    @StateObject var viewModel: PasscodeViewModel
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image(.titleIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .mask {
                        RoundedRectangle(cornerRadius: 20)
                    }
                Spacer()
            }
            Spacer()
            CustomizedButton(text: Texts.ButtonsTexts.tryAgain.rawValue) {
                viewModel.remakeAuth()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .standartBackground()
        .onAppear {
            viewModel.didLoad()
        }
    }
}

#Preview {
    PasscodeView(viewModel: .init {})
}
