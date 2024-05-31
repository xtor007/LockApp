//
//  UserViewModel.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 31.05.2024.
//

import Foundation

class UserViewModel: ObservableObject {
    
    @Published var user: EmployerModel
    @Published var average: Double
    
    @Published var alert: AlertItem?
    
    @Published var isLoadingDelete = false
    
    var shower: UserShower?
    
    init(user: EmployerModel, average: Double) {
        self.user = user
        self.average = average
    }
    
    func showLogs() {
        let viewModel = LogsViewModel(average: average, user: user)
        shower?.showLogsFromAdmin(viewModel)
    }
    
    func delete() {
        guard let id = user.id else { return }
        alert = AlertContext.dangerousActionAlert { [weak self] in
            guard let self else { return }
            DBValues.deleteEmployer(at: id)
            deleteOnServer(id)
        }
    }
    
    private func deleteOnServer(_ id: UUID) {
        isLoadingDelete = true
        Task {
            do {
                let token = try await AuthTokenDistributor().getToken()
                let request = try makeDeleteUserRequest(id: id, token: token)
                let _: ValidServerResponse = try await NetworkManager().makeRequest(request)
                DispatchQueue.main.async { [weak self] in
                    self?.shower?.dismissUser()
                }
            } catch {
                showError(error)
            }
        }
    }
    
    private func makeDeleteUserRequest(id: UUID, token: String) throws -> URLRequest {
        let maker = RequestMaker()
        try maker.addURL(UserDefaults.serverLink, endpoint: .delete, query: ["id": id.uuidString])
        maker.makeGet()
        maker.addAuthorization(token: token)
        return try maker.getRequest()
    }
    
    private func showError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isLoadingDelete = false
            alert = AlertContext.errorAlert(error: error)
        }
    }
    
}
