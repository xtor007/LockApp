//
//  AdminViewModel.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 17.05.2024.
//

import Foundation

class AdminViewModel: ObservableObject {
    
    @Published var selectedDate = Date() {
        didSet {
            loadAttendanceRisk()
        }
    }
    @Published var sortMode: AttendanceRiskSortMode = .worstRisk
    @Published private(set) var records = [AttendanceRiskDayRecord]()
    
    @Published var isLoading = false
    @Published var alert: AlertItem?
    
    let sortModes = AttendanceRiskSortMode.allCases
    
    private var shouldReloadOnAppear = false
    private var loadTask: Task<Void, Never>?

    weak var showerDelegate: AdminShowerDelegate?
    
    init() {
        loadAttendanceRisk()
    }
    
    deinit {
        loadTask?.cancel()
    }
    
    func didAppear() {
        if shouldReloadOnAppear {
            shouldReloadOnAppear = false
            loadAttendanceRisk()
        }
    }
    
    func openAddNewEmployer() {
        showerDelegate?.showAddNewEmployer(nil)
        shouldReloadOnAppear = true
    }
    
    func openStatistics(for record: AttendanceRiskDayRecord) {
        let viewModel = AttendanceUserStatisticsViewModel(user: record.user) { [weak self] in
            self?.shouldReloadOnAppear = true
        }
        viewModel.showerDelegate = showerDelegate
        showerDelegate?.showAttendanceUserStatistics(viewModel)
    }

    func updateAttendanceRisk() {
        loadAttendanceRisk()
    }
    
    var recordsToShow: [AttendanceRiskDayRecord] {
        switch sortMode {
        case .worstRisk:
            return records.sorted(by: { lhs, rhs in
                sortByRisk(lhs: lhs, rhs: rhs, descending: true)
            })
        case .bestRisk:
            return records.sorted(by: { lhs, rhs in
                sortByRisk(lhs: lhs, rhs: rhs, descending: false)
            })
        case .alphabetically:
            return records.sorted(by: { $0.user.alphabeticalKey < $1.user.alphabeticalKey })
        }
    }
    
    var selectedDateTitle: String {
        AttendanceRiskFormatter.displayDay(selectedDate)
    }
    
    private func loadAttendanceRisk() {
        let day = AttendanceRiskFormatter.apiDay(selectedDate)
        loadTask?.cancel()
        isLoading = true
        
        loadTask = Task { [weak self] in
            guard let self else { return }
            do {
                let response = try await fetchAttendanceRisk(day: day)
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    self.records = response.items
                    self.isLoading = false
                }
            } catch is CancellationError {
                ()
            } catch {
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    self.showError(error)
                }
            }
        }
    }
    
    private func fetchAttendanceRisk(day: String) async throws -> AttendanceRiskDayResponse {
        let token = try await AuthTokenDistributor().getToken()
        let request = try makeAttendanceRiskRequest(day: day, token: token)
        return try await NetworkManager().makeRequest(request)
    }
    
    private func makeAttendanceRiskRequest(day: String, token: String) throws -> URLRequest {
        let maker = RequestMaker()
        try maker.addURL(
            UserDefaults.serverLink,
            endpoint: .attendanceRiskDay,
            pathComponents: [day]
        )
        maker.makeGet()
        maker.addAuthorization(token: token)
        return try maker.getRequest()
    }
    
    private func sortByRisk(lhs: AttendanceRiskDayRecord, rhs: AttendanceRiskDayRecord, descending: Bool) -> Bool {
        switch (lhs.riskScore, rhs.riskScore) {
        case let (leftRisk?, rightRisk?):
            if leftRisk != rightRisk {
                return descending ? leftRisk > rightRisk : leftRisk < rightRisk
            }
        case (_?, nil):
            return true
        case (nil, _?):
            return false
        case (nil, nil):
            break
        }
        
        return lhs.user.alphabeticalKey < rhs.user.alphabeticalKey
    }
    
    private func showError(_ error: Error) {
        isLoading = false
        alert = AlertContext.errorAlert(error: error)
    }
    
}
