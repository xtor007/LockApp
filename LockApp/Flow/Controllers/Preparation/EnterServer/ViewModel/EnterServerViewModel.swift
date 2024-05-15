//
//  EnterServerViewModel.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import Foundation

class EnterServerViewModel: ObservableObject {
    
    @Published var server = ""
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    
    func validateServer() {
        guard !server.isEmpty else { 
            showError(EnterServerError.emptyAdress)
            return
        }
        isLoading = true
        sendRequest()
    }
    
    private func makeRequest() throws -> URLRequest {
        let maker = RequestMaker()
        try maker.addURL(server, endpoint: .validate)
        maker.makeGet()
        return try maker.getRequest()
    }
    
    private func sendRequest() {
        Task {
            do {
                let request = try makeRequest()
                let networkManager = NetworkManager()
                let validateResult: ValidServerResponse = try await networkManager.makeRequest(request)
                handleResponse(validateResult)
            } catch {
                showError(error)
            }
        }
    }
    
    private func handleResponse(_ response: ValidServerResponse) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            guard response.isValid else {
                showError(EnterServerError.validationFailed)
                return
            }
            isLoading = false
            UserDefaults.serverLink = server
        }
    }
    
    private func showError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isLoading = false
            alertItem = AlertContext.errorAlert(error: error)
        }
    }
    
}

enum EnterServerError: Error {
    case emptyAdress, validationFailed
}
