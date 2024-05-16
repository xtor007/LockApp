//
//  MainView.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewModel
    
    var body: some View {
        VStack {
            header
            Spacer()
            OpenButton(state: $viewModel.openDoorButtonState) {
                viewModel.openDoor()
            }
            Spacer()
            footer
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .alertWrapper(alertItem: $viewModel.alert)
        .standartBackground()
        .onAppear {
            viewModel.didLoad()
        }
    }
    
    @ViewBuilder
    var header: some View {
        HStack {
            Text(Texts.Main.hello.rawValue + viewModel.name)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(Color(.shadow))
            Spacer()
            UpdaterView(isLoading: $viewModel.isDataLoading) {
                viewModel.updateAllData()
            }
        }
    }
    
    @ViewBuilder
    var footer: some View {
        HStack {
            Text("\(Texts.Main.average.rawValue) \(viewModel.average.toTwoDecimalPlaces())")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color(.shadow))
            Spacer()
        }
    }
}

#Preview {
    MainView(viewModel: MainViewModel())
}
