//
//  MainViewModel.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import Foundation

class MainViewModel: ObservableObject {
    
    @Published var openDoorButtonState = OpenButtonState.ready
    
    @Published var name = ""
    @Published var average = 0.0
    
    @Published var isDataLoading = false
    
    @Published var alert: AlertItem?
    
    func didLoad() {
        updateOnScreenData()
        updateAllData()
    }
    
    func openDoor() {
        openDoorButtonState = .opening
        Task {
            do {
                let isSuccess = try await openByServer()
                updateOpenButtonState(isSuccess)
            } catch {
                updateOpenButtonState(false)
                showError(error)
            }
        }
    }
    
    func updateAllData() {
        isDataLoading = true
        Task {
            do {
                try await updateUserInfo()
                try await updateStatistic()
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    updateOnScreenData()
                    isDataLoading = false
                }
            } catch {
                showError(error)
            }
        }
    }
    
    private func updateOpenButtonState(_ isSuccess: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            openDoorButtonState = isSuccess ? .success : .failed
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 5) { [weak self] in
                guard let self else { return }
                openDoorButtonState = .ready
            }
        }
    }
    
    private func updateOnScreenData() {
        name = UserDefaults.userInfo?.name ?? ""
        average = UserDefaults.averageTime ?? 0
    }
    
    private func updateUserInfo() async throws {
        let _: Bool = try await withCheckedThrowingContinuation { continuation in
            DataRefresher().refreshData { result in
                switch result {
                case .success(_):
                    continuation.resume(returning: true)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    }
    
    private func showError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isDataLoading = false
            alert = AlertContext.errorAlert(error: error)
        }
    }
    
}
