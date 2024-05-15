//
//  ActivityIndicator.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import SwiftUI

struct ActivityIndicator: View {
    let colors: [Color]
    
    @State private var isRotateFull = true
    @State private var timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    var body: some View {
        Circle()
            .stroke(
                AngularGradient(
                    colors: colors,
                    center: .center
                ),
                style: StrokeStyle(
                    lineWidth: 4,
                    lineCap: .round
                )
            )
            .rotationEffect(.init(degrees: self.isRotateFull ? 0 : 360))
            .onReceive(
                timer,
                perform: { _ in
                    isRotateFull = true
                    rotateSpinner()
                }
            )
            .onAppear {
                isRotateFull = true
                rotateSpinner()
            }
    }
    
    init(mainColor: Color, backgroundColor: Color) {
        self.colors = [mainColor, backgroundColor, backgroundColor]
    }

    private func rotateSpinner() {
        withAnimation(.linear(duration: 2)) {
            isRotateFull = false
        }
    }
}

#Preview {
    ActivityIndicator(mainColor: Color(.accent), backgroundColor: Color(.background))
}
