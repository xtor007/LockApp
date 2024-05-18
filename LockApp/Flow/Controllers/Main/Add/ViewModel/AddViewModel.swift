//
//  AddViewModel.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 18.05.2024.
//

import Foundation

class AddViewModel: ObservableObject {
    
    @Published var name = ""
    @Published var surname = ""
    @Published var email = ""
    @Published var department = ""
    @Published var isAdmin = false
    
    @Published var alert: AlertItem?
    
    @Published var isLoading = false
    
    let close: () -> Void
    
    init(department: String? = nil, close: @escaping () -> Void) {
        self.department = department ?? ""
        self.close = close
    }
    
    func add() {
        isLoading = true
        guard validateValues() else {
            showError(AddUserError.notValidFields)
            return
        }
        Task {
            do {
                let token = try await AuthTokenDistributor().getToken()
                let request = try makeRequest(token: token)
                let _: ValidServerResponse = try await NetworkManager().makeRequest(request)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    close()
                }
            } catch {
                showError(error)
            }
        }
    }
    
    private func validateValues() -> Bool {
        validateEmail() && !name.isEmpty && !surname.isEmpty && !department.isEmpty
    }
    
    private func validateEmail() -> Bool {
        guard !email.isEmpty else { return false }
        let emailRegEx = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        guard emailPredicate.evaluate(with: email) else { return false }
        return true
    }
    
    private func makeRequest(token: String) throws -> URLRequest {
        let maker = RequestMaker()
        try maker.addURL(UserDefaults.serverLink, endpoint: .add)
        try maker.makePost(EmployerModel(
            id: UUID(),
            isAdmin: isAdmin,
            name: name,
            surname: surname,
            department: department,
            email: email
        ))
        maker.addAuthorization(token: token)
        return try maker.getRequest()
    }
    
    private func showError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isLoading = false
            alert = AlertContext.errorAlert(error: error)
        }
    }
    
}

enum AddUserError: Error {
    case notValidFields
}
