//
//  SwiftUIAlert.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import SwiftUI

struct AlertItem: Identifiable {
    var id = UUID()
    var title: Text
    var message: Text?
    var dismissButton: Alert.Button?
}

enum AlertContext {
    static let sampleAlert = AlertItem(title: Text("Sample Alert"), message: Text("This is a sample alert."), dismissButton: .default(Text("OK")))
    
    static func errorAlert(error: Error) -> AlertItem {
        AlertItem(title: Text(Texts.ErrorsTexts.error.rawValue), message: Text(error.localizedDescription), dismissButton: .default(Text(Texts.ButtonsTexts.ok.rawValue)))
    }
}

struct AlertWrapper: ViewModifier {
    @Binding var alertItem: AlertItem?
    
    func body(content: Content) -> some View {
        content
            .alert(item: $alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.dismissButton)
            }
    }
}

extension View {
    func alertWrapper(alertItem: Binding<AlertItem?>) -> some View {
        self.modifier(AlertWrapper(alertItem: alertItem))
    }
}
