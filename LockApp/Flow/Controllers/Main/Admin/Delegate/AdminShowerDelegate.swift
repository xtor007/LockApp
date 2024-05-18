//
//  AdminShowerDelegate.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 18.05.2024.
//

import Foundation

protocol AdminShowerDelegate: AnyObject {
    func showLogsFromAdmin(_ viewModel: LogsViewModel)
}
