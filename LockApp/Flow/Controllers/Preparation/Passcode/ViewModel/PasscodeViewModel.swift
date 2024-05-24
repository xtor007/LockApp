//
//  PasscodeViewModel.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 24.05.2024.
//

import Foundation
import LocalAuthentication

class PasscodeViewModel: ObservableObject {
    
    private let onSuccess: () -> Void
    
    init(onSuccess: @escaping () -> Void) {
        self.onSuccess = onSuccess
    }
    
    func didLoad() {
        authorise()
    }
    
    func remakeAuth() {
        authorise()
    }
    
    private func authorise() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = Texts.Passcode.enterPasswordMessage.rawValue
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] isSuccessed, error in
                guard let self else { return }
                if isSuccessed {
                    success()
                }
            }
        }
    }
    
    private func success() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            onSuccess()
        }
    }
    
}
