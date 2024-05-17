//
//  MainShower.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 17.05.2024.
//

import Foundation

protocol MainShower: AnyObject {
    func showLogsFromMain(_ viewModel: LogsViewModel)
}
