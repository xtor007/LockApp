//
//  AdminShowerDelegate.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 18.05.2024.
//

import Foundation

protocol AdminShowerDelegate: AnyObject {
    func showUserScreen(_ viewModel: UserViewModel)
    func showAttendanceUserStatistics(_ viewModel: AttendanceUserStatisticsViewModel)
    func showAddNewEmployer(_ department: String?)
}
