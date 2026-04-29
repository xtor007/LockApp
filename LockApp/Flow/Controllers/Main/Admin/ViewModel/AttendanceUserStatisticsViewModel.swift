//
//  AttendanceUserStatisticsViewModel.swift
//  LockApp
//
//  Created by OpenAI Codex on 30.04.2026.
//

import Foundation

class AttendanceUserStatisticsViewModel: ObservableObject {
    
    @Published private(set) var results = [AttendanceUserResult]()
    @Published var isLoading = false
    @Published var isSubmittingCorrection = false
    @Published var alert: AlertItem?
    
    let user: AttendanceRiskUserSummary
    
    weak var showerDelegate: AdminShowerDelegate?
    
    private let onCorrectionApplied: () -> Void
    private var loadTask: Task<Void, Never>?
    
    init(user: AttendanceRiskUserSummary, onCorrectionApplied: @escaping () -> Void) {
        self.user = user
        self.onCorrectionApplied = onCorrectionApplied
        loadResults()
    }
    
    deinit {
        loadTask?.cancel()
    }
    
    var resultsToShow: [AttendanceUserResult] {
        results.sorted(by: { $0.day > $1.day })
    }
    
    var canOpenUserManagement: Bool {
        managedEmployer != nil
    }
    
    func loadResults() {
        loadTask?.cancel()
        isLoading = true
        
        let userId = user.id
        loadTask = Task { [weak self] in
            guard let self else { return }
            do {
                let response = try await fetchResults(userId: userId)
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    self.results = response.results
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
    
    func openUserManagement() {
        guard let managedEmployer else { return }
        let viewModel = UserViewModel(user: managedEmployer.employer, average: managedEmployer.average)
        showerDelegate?.showUserScreen(viewModel)
    }
    
    func submitCorrection(for result: AttendanceUserResult, etaValue: Double, onSuccess: @escaping () -> Void) {
        guard (0 ... 1).contains(etaValue) else {
            showError(AttendanceCorrectionError.invalidPercent)
            return
        }
        
        isSubmittingCorrection = true
        Task { [weak self] in
            guard let self else { return }
            do {
                _ = try await sendCorrection(userId: user.id, day: result.day, etaValue: etaValue)
                await MainActor.run {
                    self.isSubmittingCorrection = false
                    self.onCorrectionApplied()
                    onSuccess()
                    self.loadResults()
                }
            } catch {
                await MainActor.run {
                    self.showError(error)
                }
            }
        }
    }
    
    private func fetchResults(userId: UUID) async throws -> AttendanceUserResultsResponse {
        let token = try await AuthTokenDistributor().getToken()
        let request = try makeResultsRequest(userId: userId, token: token)
        return try await NetworkManager().makeRequest(request)
    }
    
    private func sendCorrection(userId: UUID, day: String, etaValue: Double) async throws -> AttendanceMLPFeedbackResponse {
        let token = try await AuthTokenDistributor().getToken()
        let request = try makeCorrectionRequest(userId: userId, day: day, etaValue: etaValue, token: token)
        return try await NetworkManager().makeRequest(request)
    }
    
    private func makeResultsRequest(userId: UUID, token: String) throws -> URLRequest {
        let maker = RequestMaker()
        try maker.addURL(
            UserDefaults.serverLink,
            endpoint: .attendanceUsers,
            pathComponents: [userId.uuidString, "results"]
        )
        maker.makeGet()
        maker.addAuthorization(token: token)
        return try maker.getRequest()
    }
    
    private func makeCorrectionRequest(userId: UUID, day: String, etaValue: Double, token: String) throws -> URLRequest {
        let maker = RequestMaker()
        try maker.addURL(UserDefaults.serverLink, endpoint: .attendanceMLPFeedback)
        try maker.makePost(AttendanceMLPFeedbackRequest(userId: userId, day: day, etaNn: etaValue))
        maker.addAuthorization(token: token)
        return try maker.getRequest()
    }
    
    private var managedEmployer: EmployerDBModel? {
        DBValues.employers.first(where: { $0.employer.id == user.id })
    }
    
    private func showError(_ error: Error) {
        isLoading = false
        isSubmittingCorrection = false
        alert = AlertContext.errorAlert(error: error)
    }
    
}

enum AttendanceCorrectionError: LocalizedError {
    case invalidPercent
    
    var errorDescription: String? {
        switch self {
        case .invalidPercent:
            Texts.Attendance.invalidCorrectionPercent.rawValue
        }
    }
}
