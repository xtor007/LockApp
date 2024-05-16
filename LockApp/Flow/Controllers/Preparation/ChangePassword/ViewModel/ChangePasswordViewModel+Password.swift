//
//  ChangePasswordViewModel+Password.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import Foundation

extension ChangePasswordViewModel {
    func sendPassword() {
        Task {
            do {
                try validatePassword()
                let request = try makeSendPasswordRequest()
                let _: ValidServerResponse = try await NetworkManager().makeRequest(request)
                passwordWasChanged()
            } catch {
                showError(error)
            }
        }
    }
    
    private func validatePassword() throws {
        guard !password.isEmpty else { throw SendNewPasswordError.passwordEmpty }
        guard password == confirmPassword else { throw SendNewPasswordError.passwordsMismatch }
    }
    
    private func makeSendPasswordRequest() throws -> URLRequest {
        let maker = RequestMaker()
        try maker.addURL(UserDefaults.serverLink, endpoint: .changePassword)
        try maker.makePost(PasswordContainer(password: password))
        try maker.addAuthorization(login: email, password: code)
        return try maker.getRequest()
    }
    
    private func passwordWasChanged() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isLoading = false
            closeAction()
        }
    }
}

enum SendNewPasswordError: Error {
    case passwordsMismatch, passwordEmpty
}
