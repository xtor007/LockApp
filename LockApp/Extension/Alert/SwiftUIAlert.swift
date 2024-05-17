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
    var okButton: Alert.Button?
}

enum AlertContext {
    static let sampleAlert = AlertItem(title: Text("Sample Alert"), message: Text("This is a sample alert."), dismissButton: .default(Text("OK")))
    
    static func errorAlert(error: Error) -> AlertItem {
        AlertItem(title: Text(Texts.AlertTexts.error.rawValue), message: Text(error.localizedDescription), dismissButton: .default(Text(Texts.ButtonsTexts.ok.rawValue)))
    }
    
    static func dangerousActionAlert(onOkTap: @escaping () -> Void) -> AlertItem {
        AlertItem(
            title: Text(Texts.AlertTexts.dangerous.rawValue),
            message: Text(Texts.AlertTexts.areYouSure.rawValue),
            dismissButton: .cancel(),
            okButton: .default(Text(Texts.ButtonsTexts.ok.rawValue), action: onOkTap)
        )
    }
}

struct AlertWrapper: ViewModifier {
    @Binding var alertItem: AlertItem?
    
    func body(content: Content) -> some View {
        content
            .alert(item: $alertItem) { alertItem in
                if let dismissButton = alertItem.dismissButton,
                   let okButton = alertItem.okButton {
                    Alert(
                        title: alertItem.title,
                        message: alertItem.message,
                        primaryButton: dismissButton,
                        secondaryButton: okButton
                    )
                } else {
                    Alert(
                        title: alertItem.title,
                        message: alertItem.message,
                        dismissButton: alertItem.dismissButton
                    )
                }
            }
    }
}

extension View {
    func alertWrapper(alertItem: Binding<AlertItem?>) -> some View {
        self.modifier(AlertWrapper(alertItem: alertItem))
    }
}
