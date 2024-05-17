//
//  StatisticDiagram.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 16.05.2024.
//

import SwiftUI

enum StatisticScrollDirection {
    case forward, back
}

struct StatisticDiagram: View {
    @Binding var columns: [StatisticDiagramColumn]
    @Binding var startDate: Date
    @Binding var finishDate: Date
    let scroll: (StatisticScrollDirection) -> Void
    
    let statWidth: CGFloat = 0.07
    
    var body: some View {
        VStack {
            header
            diagram
            HStack(spacing: 10) {
                button(direction: .back)
                date
                button(direction: .forward)
            }
            .font(.system(size: 18))
            .foregroundStyle(Color(.accent))
        }
    }
    
    @ViewBuilder
    var header: some View {
        let days = ["Mon", "Thu", "Wed", "Thu", "Fri", "Sat", "Sun"]
        HStack {
            ForEach(days, id: \.self) { day in
                Spacer()
                Text(day)
                    .font(.system(size: 16))
                    .foregroundStyle(Color(.grayAccent))
                    .frame(width: 34)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    var diagram: some View {
        GeometryReader(content: { geometry in
            ZStack(alignment: .topLeading) {
                dividers
                ForEach(0..<columns.count, id: \.self) { index in
                    statisticColumn(columns[index], index: index, geo: geometry)
                }
            }
        })
    }
    
    @ViewBuilder
    func statisticColumn(_ column: StatisticDiagramColumn, index: Int, geo: GeometryProxy) -> some View {
        ForEach(0..<column.segments.count, id: \.self) { segmentIndex in
            segmant(column.segments[segmentIndex], columnIndex: index, geo: geo)
        }
    }
    
    @ViewBuilder
    func segmant(_ segment: StatisticDiagramSegment, columnIndex: Int, geo: GeometryProxy) -> some View {
        Capsule()
            .fill(Color(.accent))
            .frame(
                width: geo.size.width * statWidth,
                height: geo.size.height * (segment.finish - segment.start)
            )
            .offset(
                x: calculateXOffset(index: columnIndex) * geo.size.width,
                y: geo.size.height * segment.start
            )
    }
    
    @ViewBuilder
    var dividers: some View {
        HStack {
            ForEach(0...columns.count, id: \.self) { index in
                Rectangle()
                    .fill(Color(.grayAccent))
                    .frame(width: 5)
                if index != columns.count {
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder var date: some View {
        Text(startDate.formattedDayMonth())
            .frame(width: 50)
        Text(" ... ")
        Text(finishDate.formattedDayMonth())
            .frame(width: 50)
    }
    
    @ViewBuilder
    func button(direction: StatisticScrollDirection) -> some View {
        Button {
            withAnimation {
                scroll(direction)
            }
        } label: {
            Image(systemName: buttonName(direction))
                .resizable()
                .scaledToFit()
                .frame(width: 25)
                .foregroundStyle(Color(.accent))
        }
    }
    
    func buttonName(_ direction: StatisticScrollDirection) -> String {
        switch direction {
        case .forward:
            "arrow.turn.up.right"
        case .back:
            "arrow.turn.up.left"
        }
    }
    
    func calculateXOffset(index: Int) -> CGFloat {
        let offset = ((1 / CGFloat(columns.count)) - statWidth) / 2
        return offset + CGFloat(index) * (offset + offset + statWidth)
    }
}

#Preview {
    StatisticDiagram(
        columns: .constant([
            StatisticDiagramColumn(segments: [
                .init(start: 0.3, finish: 0.5),
                .init(start: 0.6, finish: 0.9)
            ]),
            StatisticDiagramColumn(segments: [
                .init(start: 0.2, finish: 0.5),
                .init(start: 0.55, finish: 0.9)
            ]),
            StatisticDiagramColumn(segments: [
                .init(start: 0.3, finish: 0.5)
            ]),
            StatisticDiagramColumn(segments: [
                .init(start: 0.3, finish: 0.5),
                .init(start: 0.6, finish: 0.62),
                .init(start: 0.9, finish: 0.95)
            ]),
            StatisticDiagramColumn(segments: [
                .init(start: 0.3, finish: 0.5),
                .init(start: 0.6, finish: 0.9)
            ]),
            StatisticDiagramColumn(segments: []),
            StatisticDiagramColumn(segments: [
                .init(start: 0.3, finish: 0.5),
                .init(start: 0.6, finish: 0.9)
            ])
        ]),
        startDate: .constant(.now),
        finishDate: .constant(.now)
    ) {_ in }
        .frame(height: 400)
        .padding(.horizontal, 20)
}
