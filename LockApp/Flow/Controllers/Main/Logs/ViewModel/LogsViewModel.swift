//
//  LogsViewModel.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 17.05.2024.
//

import Foundation

class LogsViewModel: ObservableObject {
    
    @Published var logs: [EnterDBModel]?
    @Published var average: Double
    @Published var name: String
    @Published var surname: String
    private let id: UUID?
    
    @Published var isLoading = false
    
    @Published var alert: AlertItem?
    
    init(average: Double, user: EmployerModel, logs: [EnterDBModel]? = nil) {
        self.average = average
        name = user.name ?? ""
        surname = user.surname ?? ""
        id = user.id
        if let logs {
            self.logs = logs
        } else {
            isLoading = true
            loadLogsIfNeeded()
        }
    }
    
    private func loadLogsIfNeeded() {
        loadLogsFromDB()
        if !NetworkMonitor().checkInternetConnectivity() {
            isLoading = false
            return
        }
        guard let id else {
            showError(LogsError.noId)
            return
        }
        Task {
            do {
                try await loadLogsFromServer(id: id)
            } catch {
                showError(error)
            }
        }
    }
    
    private func loadLogsFromServer(id: UUID) async throws {
        let lastDate = (logs?.isEmpty ?? true) ? nil : logs![0].time
        let _: Bool = try await withCheckedThrowingContinuation { continuation in
            LogsRefresher(id: id, fromDate: lastDate).refreshData { result in
                switch result {
                case .success(_):
                    continuation.resume(returning: true)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isLoading = false
            loadLogsFromDB()
        }
    }
    
    private func loadLogsFromDB() {
        logs = DBValues.enters
            .filter({ $0.employerId == self.id })
            .sorted(by: { $0.time > $1.time })
    }
    
    private func showError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isLoading = false
            alert = AlertContext.errorAlert(error: error)
        }
    }
    
}

enum LogsError: Error {
    case noId
}
