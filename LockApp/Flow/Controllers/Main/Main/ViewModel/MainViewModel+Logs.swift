//
//  MainViewModel+Logs.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 17.05.2024.
//

import Foundation

extension MainViewModel {
    
    func updateDiagramData() {
        let weeksEnters = Array(
            enters
                .filter({ $0.time >= startDate && $0.time <= finishDate })
                .reversed()
        )
        let weekPerDayEnters = (0..<7).map( { entersInDay(weeksEnters, day: $0) } )
        statisticColomns = weekPerDayEnters.map({ enters in
                .init(segments: makeSegments(enters))
        })
    }
    
    private func entersInDay(_ enters: [EnterDBModel], day: Int) -> [EnterDBModel] {
        let dayStart = startDate.date(addings: day)
        let dayFinish = startDate.date(addings: day + 1)
        var result = enters.filter({ $0.time >= dayStart && $0.time < dayFinish })
        if dayStart.isSameDay(.now) && isNeededAddNowAsEnter {
            result.append(.init(id: UUID(), employerId: UUID(), time: .now, isOn: false))
        }
        return result
    }
    
    private func makeSegments(_ enters: [EnterDBModel]) -> [StatisticDiagramSegment] {
        var segmentStart = 0.0
        var result = [StatisticDiagramSegment]()
        for enter in enters {
            if enter.isOn {
                segmentStart = enter.time.percentOfDayPassed()
            } else {
                result.append(.init(start: segmentStart, finish: enter.time.percentOfDayPassed()))
                segmentStart = 0
            }
        }
        if segmentStart != 0 {
            result.append(.init(start: segmentStart, finish: 1))
        }
        return result
    }
    
    private var isNeededAddNowAsEnter: Bool {
        if enters.count == 0 { return false }
        return enters[0].isOn
    }
    
}
