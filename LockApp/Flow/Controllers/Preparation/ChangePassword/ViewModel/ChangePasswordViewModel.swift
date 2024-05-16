//
//  ChangePasswordViewModel.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import Foundation

class ChangePasswordViewModel: ObservableObject {
    
    enum ChangePasswordState {
        case email, code, password
    }
    
    let closeAction: () -> Void
    
    @Published var state = ChangePasswordState.email {
        didSet {
            updateButtons()
        }
    }
    
    @Published var email = ""
    @Published var code = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var isPrevButtonAvailiable = false
    @Published var isNextButtonAvailiable = true
    @Published var nextButtonText = Texts.ButtonsTexts.next.rawValue
    
    @Published var isLoading = false {
        didSet {
            if isLoading {
                isPrevButtonAvailiable = false
                isResendOnScreen = false
            } else {
                updateButtons()
            }
        }
    }
    @Published var isResendCode = false {
        didSet {
            if isResendCode {
                isPrevButtonAvailiable = false
                isNextButtonAvailiable = false
            } else {
                updateButtons()
            }
        }
    }
    @Published var isResendOnScreen = false
    
    @Published var alert: AlertItem?
    
    var realCode: String?
    
    init(closeAction: @escaping () -> Void) {
        self.closeAction = closeAction
    }
    
    private func updateButtons() {
        switch state {
        case .email:
            isPrevButtonAvailiable = false
            isNextButtonAvailiable = true
            nextButtonText = Texts.ButtonsTexts.next.rawValue
            isResendOnScreen = false
        case .code:
            isPrevButtonAvailiable = true
            isNextButtonAvailiable = true
            nextButtonText = Texts.ButtonsTexts.next.rawValue
            isResendOnScreen = true
        case .password:
            isPrevButtonAvailiable = true
            isNextButtonAvailiable = true
            nextButtonText = Texts.ButtonsTexts.confirm.rawValue
            isResendOnScreen = false
        }
    }
    
    func next() {
        switch state {
        case .email:
            isLoading = true
            sendCode()
        case .code:
            if code == realCode {
                state = .password
            } else {
                showError(CodeError.codeFailed)
            }
        case .password:
            isLoading = true
            sendPassword()
        }
    }
    
    func prev() {
        switch state {
        case .email:
            ()
        case .code:
            state = .email
        case .password:
            state = .code
        }
    }
    
    func resendCode() {
        isResendCode = true
        sendCode()
    }
    
    func showError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isResendCode = false
            isLoading = false
            alert = AlertContext.errorAlert(error: error)
        }
    }
    
}

enum CodeError: Error {
    case codeFailed
}
