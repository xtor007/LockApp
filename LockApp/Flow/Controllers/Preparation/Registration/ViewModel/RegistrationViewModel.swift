//
//  RegistrationViewModel.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var alert: AlertItem?
    
    private weak var showerDelegate: RegistrationShowerDelegate?
    
    init(delegate: RegistrationShowerDelegate) {
        showerDelegate = delegate
    }
    
    func login() {
        isLoading = true
        Task {
            do {
                let request = try makeRequest()
                let tokens = try await sendRequest(request)
                updateTokens(tokens)
            } catch {
                showError(error)
            }
        }
    }
    
    func changeServer() {
        UserDefaults.serverLink = nil
    }
    
    func forgotPassword() {
        showerDelegate?.showChangePasswordFromRegistration()
    }
    
    private func showError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isLoading = false
            alert = AlertContext.errorAlert(error: error)
        }
    }
    
    private func updateTokens(_ tokens: AuthTokens) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            isLoading = false
            
            UserDefaults.expirationDate = tokens.expDate
            KeychainValues.authToken = tokens.auth
            KeychainValues.refreshToken = tokens.refresh
            
            showerDelegate?.showMain()
        }
    }
    
}

// MARK: - Network

extension RegistrationViewModel {
    private func makeRequest() throws -> URLRequest {
        guard !email.isEmpty && !password.isEmpty else { throw RegistrationError.emptyFields }
        let maker = RequestMaker()
        try maker.addURL(UserDefaults.serverLink, endpoint: .getToken)
        maker.makeGet()
        try maker.addAuthorization(login: email, password: password)
        return try maker.getRequest()
    }
    
    private func sendRequest(_ request: URLRequest) async throws -> AuthTokens {
        let networkManager = NetworkManager()
        return try await networkManager.makeRequest(request)
    }
}

enum RegistrationError: Error {
    case emptyFields
}
