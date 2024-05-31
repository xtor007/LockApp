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
        updateUIItems()
    }
    
    func openAddNewEmployer() {
        let department = filter == .all ? nil : filter.text
        showerDelegate?.showAddNewEmployer(department)
        shoulReloadOnApperar = true
    }
    
    func openUser(average: Double, user: EmployerModel) {
        let viewModel = UserViewModel(user: user, average: average)
        showerDelegate?.showUserScreen(viewModel)
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
    
    private func showError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isLoading = false
            alert = AlertContext.errorAlert(error: error)
        }
    }
    
}
