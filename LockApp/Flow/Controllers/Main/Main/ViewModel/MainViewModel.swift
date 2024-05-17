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
    
    @Published var statisticColomns: [StatisticDiagramColumn] = Array(repeating: StatisticDiagramColumn(segments: []), count: 7)
    @Published var startDate: Date = .now.startOfWeek()
    @Published var finishDate: Date = .now.endOfWeek()
    
    var enters = [EnterDBModel]()
    
    weak var showerDelegate: MainShower?
    
    // MARK: - Life
    
    init() {
        updateDiagramData()
        updateOnScreenData()
        updateAllData()
    }
    
    func didLoad() {}
    
    // MARK: Buttons click
    
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
    
    func openLogs() {
        guard let user = UserDefaults.userInfo else { return }
        let logsViewModel = LogsViewModel(average: average, user: user, logs: enters)
        showerDelegate?.showLogsFromMain(logsViewModel)
    }
    
    func strollDiagram(_ direction: StatisticScrollDirection) {
        guard let newStart = formNewDate(startDate, direction: direction),
              let newFinish = formNewDate(finishDate, direction: direction) else {
            return
        }
        startDate = newStart
        finishDate = newFinish
        updateDiagramData()
    }
    
    private func formNewDate(_ date: Date, direction: StatisticScrollDirection) -> Date? {
        switch direction {
        case .forward:
            date.weekForward()
        case .back:
            date.weekBack()
        }
    }
    
    // MARK: - Update
    
    func updateAllData() {
        isDataLoading = true
        Task {
            do {
                try await updateUserInfo()
                try await updateStatistic()
                try await updateLogs()
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
        enters = DBValues.enters
            .filter({ $0.employerId == UserDefaults.userInfo?.id })
            .sorted(by: { $0.time > $1.time })
        updateDiagramData()
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
    
    private func updateLogs() async throws {
        let _: Bool = try await withCheckedThrowingContinuation { continuation in
            guard let id = UserDefaults.userInfo?.id else {
                continuation.resume(throwing: MainViewModelError.noId)
                return
            }
            let lastDate = enters.count == 0 ? nil : enters[0].time
            LogsRefresher(id: id, fromDate: lastDate).refreshData { result in
                switch result {
                case .success(_):
                    continuation.resume(returning: true)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    }
    
    // MARK: - Error
    
    private func showError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isDataLoading = false
            alert = AlertContext.errorAlert(error: error)
        }
    }
    
}

enum MainViewModelError: Error {
    case noId
}
