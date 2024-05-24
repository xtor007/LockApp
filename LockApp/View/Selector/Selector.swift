//
//  Selector.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 24.05.2024.
//

import SwiftUI

protocol SelectorItem: Equatable {
    var name: String { get }
}

struct Selector<T: SelectorItem>: View {
    @State var items: [T]
    @Binding var selectedItem: T
    
    var body: some View {
        HStack {
            ForEach(0..<items.count, id: \.self) { index in
                item(index)
            }
        }
        .frame(height: 50)
        .padding(.horizontal, 6)
        .background {
            Capsule()
                .stroke(lineWidth: 4)
                .fill(Color(.accent))
        }
    }
    
    @ViewBuilder
    func item(_ index: Int) -> some View {
        let item = items[index]
        let isSelected = item == selectedItem
        HStack {
            Spacer()
            Text(item.name)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color(isSelected ? .background : .shadow))
            Spacer()
        }
        .padding(.vertical, 8)
        .background {
            if isSelected {
                Capsule()
                    .fill(Color(.accent))
            }
        }
        .onTapGesture {
            withAnimation {
                selectedItem = item
            }
        }
    }
}

#Preview {
    Selector(items: [
        PreviewItem(name: "first"),
        PreviewItem(name: "second"),
        PreviewItem(name: "third")
    ], selectedItem: .constant(PreviewItem(name: "third")))
}

struct PreviewItem: SelectorItem {
    let name: String
}
