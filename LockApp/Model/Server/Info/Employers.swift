//
//  Employers.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 17.05.2024.
//

import Foundation

struct Employers: Codable {
    let employers: [EmployerWithStatistic]
}

struct EmployerWithStatistic: Codable {
    let employer: EmployerModel
    let statistic: Statistic
}
