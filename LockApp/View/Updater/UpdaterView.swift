//
//  UpdaterView.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import SwiftUI

struct UpdaterView: View {
    @Binding var isLoading: Bool
    let onTap: () -> Void
    
    var body: some View {
        updater
            .frame(width: 35, height: 35)
    }
    
    @ViewBuilder
    var updater: some View {
        if isLoading {
            ActivityIndicator(mainColor: Color(.accent), backgroundColor: Color(.background))
        } else {
            Button(action: onTap, label: {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .resizable()
                    .foregroundStyle(Color(.accent))
            })
        }
    }
}

#Preview {
    UpdaterView(isLoading: .constant(false)) {}
}
