//
//  UserShower.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 31.05.2024.
//

import Foundation

protocol UserShower {
    func showLogsFromAdmin(_ viewModel: LogsViewModel)
    func dismissUser()
}
