//
//  AttendanceDepartmentHistogramViewModel.swift
//  LockApp
//
//  Created by OpenAI Codex on 07.05.2026.
//

import Foundation

final class AttendanceDepartmentHistogramViewModel: ObservableObject {
    enum RiskBucket: String, CaseIterable, Identifiable {
        case stableNormal
        case green
        case blue
        case red

        var id: String {
            rawValue
        }

        var responseKey: String {
            switch self {
            case .stableNormal:
                return "stable_normal"
            case .green:
                return "green"
            case .blue:
                return "blue"
            case .red:
                return "red"
            }
        }
    }

    struct HistogramItem: Identifiable {
        let bucket: RiskBucket
        let count: Int

        var id: String {
            bucket.id
        }
    }

    @Published private(set) var startDate: Date
    @Published private(set) var endDate: Date
    @Published private(set) var selectedDepartment: DepartmentFilter = .all
    @Published private(set) var departmentOptions = [DepartmentFilter.all]
    @Published private(set) var histogramItems: [HistogramItem]
    @Published private(set) var totalCount = 0
    @Published private(set) var isLoading = false
    @Published var alert: AlertItem?

    let maximumDate: Date

    private let calendar: Calendar
    private var loadTask: Task<Void, Never>?

    init(calendar: Calendar = .current, today: Date = Date()) {
        self.calendar = calendar
        self.maximumDate = calendar.startOfDay(for: today)
        self.endDate = self.maximumDate
        self.startDate = calendar.date(byAdding: .day, value: -30, to: self.maximumDate) ?? self.maximumDate
        self.histogramItems = RiskBucket.allCases.map { HistogramItem(bucket: $0, count: 0) }
        loadData(loadDepartments: true)
    }

    deinit {
        loadTask?.cancel()
    }

    var filteredRecordsCount: Int {
        totalCount
    }

    func updateStartDate(_ date: Date) {
        let normalizedDate = normalized(date)
        startDate = normalizedDate
        if startDate > endDate {
            endDate = startDate
        }
        loadData()
    }

    func updateEndDate(_ date: Date) {
        let normalizedDate = min(normalized(date), maximumDate)
        endDate = normalizedDate
        if endDate < startDate {
            startDate = endDate
        }
        loadData()
    }

    func selectDepartment(_ department: DepartmentFilter) {
        guard selectedDepartment != department else { return }
        selectedDepartment = department
        loadData()
    }

    func refresh() {
        loadData(loadDepartments: true)
    }
}

private extension AttendanceDepartmentHistogramViewModel {
    func normalized(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    func loadData(loadDepartments: Bool = false) {
        loadTask?.cancel()
        isLoading = true

        let startDay = AttendanceRiskFormatter.apiDay(startDate)
        let endDay = AttendanceRiskFormatter.apiDay(endDate)
        let currentDepartment = selectedDepartment

        loadTask = Task { [weak self] in
            guard let self else { return }
            do {
                let token = try await AuthTokenDistributor().getToken()
                let fetchedDepartments = loadDepartments
                    ? try await fetchDepartments(token: token)
                    : departmentOptions
                let effectiveDepartment = fetchedDepartments.contains(currentDepartment) ? currentDepartment : .all
                let histogram = try await fetchHistogram(
                    token: token,
                    startDay: startDay,
                    endDay: endDay,
                    department: effectiveDepartment
                )

                guard !Task.isCancelled else { return }

                await MainActor.run {
                    self.departmentOptions = fetchedDepartments
                    self.selectedDepartment = effectiveDepartment
                    self.apply(histogram: histogram)
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

    func fetchDepartments(token: String) async throws -> [DepartmentFilter] {
        let request = try makeDepartmentsRequest(token: token)
        let response: AttendanceRiskDepartmentsResponse = try await NetworkManager().makeRequest(request)
        return [.all] + response.departments.map { DepartmentFilter.other($0) }
    }

    func fetchHistogram(
        token: String,
        startDay: String,
        endDay: String,
        department: DepartmentFilter
    ) async throws -> AttendanceRiskHistogramResponse {
        let request = try makeHistogramRequest(
            token: token,
            startDay: startDay,
            endDay: endDay,
            department: department
        )
        return try await NetworkManager().makeRequest(request)
    }

    func makeDepartmentsRequest(token: String) throws -> URLRequest {
        let maker = RequestMaker()
        try maker.addURL(
            UserDefaults.serverLink,
            endpoint: .attendanceRiskDepartments
        )
        maker.makeGet()
        maker.addAuthorization(token: token)
        return try maker.getRequest()
    }

    func makeHistogramRequest(
        token: String,
        startDay: String,
        endDay: String,
        department: DepartmentFilter
    ) throws -> URLRequest {
        var query = [
            "startDay": startDay,
            "endDay": endDay
        ]

        if case .other(let departmentName) = department {
            query["department"] = departmentName
        }

        let maker = RequestMaker()
        try maker.addURL(
            UserDefaults.serverLink,
            endpoint: .attendanceRiskHistogram,
            query: query
        )
        maker.makeGet()
        maker.addAuthorization(token: token)
        return try maker.getRequest()
    }

    func apply(histogram: AttendanceRiskHistogramResponse) {
        let countsByKey = Dictionary(uniqueKeysWithValues: histogram.buckets.map { ($0.key, $0.count) })
        histogramItems = RiskBucket.allCases.map { bucket in
            HistogramItem(bucket: bucket, count: countsByKey[bucket.responseKey] ?? 0)
        }
        totalCount = histogram.totalCount
    }

    func showError(_ error: Error) {
        isLoading = false
        alert = AlertContext.errorAlert(error: error)
    }
}
