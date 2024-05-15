//
//  LoadingView.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import SwiftUI

struct LoadingView: View {
    @StateObject var viewModel: LoadingViewModel
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 10) {
                Spacer()
                ActivityIndicator(
                    mainColor: Color(.accent),
                    backgroundColor: Color(.background)
                )
                .frame(width: 30)
                Text(Texts.Loading.loadingMessage.rawValue)
                    .font(.system(size: 20))
                    .foregroundStyle(Color(.shadow))
                Spacer()
            }
            Spacer()
        }
        .standartBackground()
        .onAppear {
            viewModel.didLoad()
        }
    }
}

#Preview {
    LoadingView(viewModel: LoadingViewModel(task: {
        ()
    }))
}
