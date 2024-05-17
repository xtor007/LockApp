//
//  StstisticDiagramColumn.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import Foundation

struct StatisticDiagramColumn {
    let segments: [StatisticDiagramSegment]
}

struct StatisticDiagramSegment {
    let start: Double
    let finish: Double
}
