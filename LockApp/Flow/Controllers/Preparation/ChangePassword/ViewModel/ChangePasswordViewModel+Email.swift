//
//  ChangePasswordViewModel+Email.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import Foundation

extension ChangePasswordViewModel {
    func sendCode() {
        Task {
            do {
                try validateEmail(email)
                let request = try makeSendEmailRequest()
                let code: ChangePasswordCode = try await NetworkManager().makeRequest(request)
                emailSendedSuccesed(code.code)
            } catch {
                showError(error)
            }
        }
    }
    
    private func validateEmail(_ email: String) throws {
        guard !email.isEmpty else { throw SendCodeToEmailError.failedEmail }
        let emailRegEx = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        guard emailPredicate.evaluate(with: email) else { throw SendCodeToEmailError.failedEmail }
    }
    
    private func makeSendEmailRequest() throws -> URLRequest {
        let maker = RequestMaker()
        try maker.addURL(UserDefaults.serverLink, endpoint: .sendEmail)
        try maker.makePost(ChangePasswordEmail(email: email))
        return try maker.getRequest()
    }
    
    private func emailSendedSuccesed(_ code: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            realCode = code
            isLoading = false
            isResendCode = false
            state = .code
        }
    }
}

enum SendCodeToEmailError: Error {
    case failedEmail
}
