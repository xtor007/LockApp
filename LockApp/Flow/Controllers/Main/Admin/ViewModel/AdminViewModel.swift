//
//  AdminViewModel.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 17.05.2024.
//

import Foundation

class AdminViewModel: ObservableObject {
    
    @Published var filter = DepartmentFilter.all {
        didSet {
            updateFilteredData()
        }
    }
    @Published var filters = [DepartmentFilter.all]
    
    @Published var employersToShow = [EmployerDBModel]()
    var employers = [EmployerDBModel]() {
        didSet {
            updateFilteredData()
        }
    }
    
    @Published var isLoading = false
    
    @Published var alert: AlertItem?
    
    private var shoulReloadOnApperar = false
    
    weak var showerDelegate: AdminShowerDelegate?
    
    init() {
        updateUIItems()
        updateEmployers()
    }
    
    func didAppear() {
        if shoulReloadOnApperar {
            updateEmployers()
            shoulReloadOnApperar = false
        }
    }
    
    func openAddNewEmployer() {
        let department = filter == .all ? nil : filter.text
        showerDelegate?.showAddNewEmployer(department)
        shoulReloadOnApperar = true
    }
    
    func openLogs(average: Double, user: EmployerModel) {
        let viewModel = LogsViewModel(average: average, user: user)
        showerDelegate?.showLogsFromAdmin(viewModel)
    }
    
    func removeEmployer(id: UUID?) {
        guard let id else { return }
        alert = AlertContext.dangerousActionAlert { [weak self] in
            guard let self else { return }
            DBValues.deleteEmployer(at: id)
            deleteOnServer(id)
            updateUIItems()
        }
    }
    
    func updateFilteredData() {
        switch filter {
        case .all:
            employersToShow = employers
        case .other(let department):
            employersToShow = employers.filter({ $0.employer.department == department })
        }
    }
    
    func updateEmployers() {
        isLoading = true
        Task {
            do {
                try await refreshData()
                updateUIItems()
            } catch {
                showError(error)
            }
        }
    }
    
    private func refreshData() async throws {
        let _: Bool = try await withCheckedThrowingContinuation { contonuation in
            EmployersRefresher().refreshData { result in
                switch result {
                case .success(_):
                    contonuation.resume(returning: true)
                case .failure(let failure):
                    contonuation.resume(throwing: failure)
                }
            }
        }
    }
    
    private func updateUIItems() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isLoading = false
            employers = DBValues.employers
                .sorted(by: { ($0.employer.surname ?? "") < ($1.employer.surname ?? "") })
            filters = [.all] + departments.map({ .other($0) })
            if !filters.contains(where: { $0 == self.filter }) {
                filter = .all
            }
            updateFilteredData()
        }
    }
    
    private var departments: [String] {
        var departments = Set<String>()
        employers.forEach({ employer in
            guard let department = employer.employer.department else { return }
            departments.insert(department)
        })
        return departments.sorted()
    }
    
    var average: Double {
        guard employersToShow.count != 0 else { return 0 }
        return employersToShow.reduce(0.0, { $0 + $1.average }) / Double(employersToShow.count)
    }
    
    private func deleteOnServer(_ id: UUID) {
        isLoading = true
        Task {
            do {
                let token = try await AuthTokenDistributor().getToken()
                let request = try makeDeleteUserRequest(id: id, token: token)
                let _: ValidServerResponse = try await NetworkManager().makeRequest(request)
                updateUIItems()
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
            isLoading = false
            alert = AlertContext.errorAlert(error: error)
        }
    }
    
}
