//
//  CheckmarkWithText.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 18.05.2024.
//

import SwiftUI

struct CheckmarkWithText: View {
    @State var text: String
    @Binding var isChecked: Bool
    
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 25))
                .foregroundStyle(Color(UIColor.lightGray))
            Spacer()
            Checkmark(isChecked: $isChecked)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background {
            Capsule()
                .stroke(lineWidth: 2)
                .fill(Color(.grayAccent))
                .shadow(color: Color(.shadow), radius: 1)
        }
    }
}

struct Checkmark: View {
    @Binding var isChecked: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
                .fill(color)
                .frame(width: 30, height: 30)
            if isChecked {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
                    .frame(width: 25, height: 25)
            }
        }
        .onTapGesture {
            withAnimation {
                isChecked.toggle()
            }
        }
    }
    
    var color: Color {
        Color(isChecked ? .accent : .grayAccent)
    }
}

#Preview {
    VStack {
        CheckmarkWithText(text: "123", isChecked: .constant(true))
        CheckmarkWithText(text: "123", isChecked: .constant(false))
    }
}
