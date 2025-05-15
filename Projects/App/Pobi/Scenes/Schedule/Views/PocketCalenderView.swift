//
//  PocketCalenderView.swift
//  Pobi
//
//  Created by 이시원 on 4/30/25.
//

import SwiftUI

import PBCalender
import PBDesignSystem

struct PocketCalenderView: View {
  @EnvironmentObject private var formatter: PBFormatter
  @EnvironmentObject private var calender: PBCalenderManager
  @State private var selectedDate: Date
  
  init(seletedDate: Date) {
    self.selectedDate = seletedDate
  }
  
  var body: some View {
    VStack {
      HStack {
        ForEach(calender.weekdays, id: \.self) { weekday in
          Text(formatter.weekDay(weekday) ?? "")
            .font(PBFonts.body._4.font)
            .foregroundStyle(weekday == 1 ? PBColors.red.color : PBColors.navy._100.color)
            .frame(maxWidth: .infinity)
        }
      }
      .frame(height: 31)
      .padding(.horizontal, 4)
      GeometryReader { geometry in
        LazyVGrid(
          columns: Array(repeating: GridItem(spacing: 0), count: 7),
          spacing: 0
        ) {
          let days = calender.days(in: selectedDate)
          ForEach(0..<days.count, id: \.self) { i in
            ZStack {
              if days[i].isToday {
                RoundedRectangle(cornerRadius: 8)
              }
              VStack {
                Text("\(days[i].day)")
                  .font(PBFonts.label._1.font)
                  .foregroundStyle(dayLabelColor(week: calender.weekdays[i%7], item: days[i]))
                Spacer()
              }
              .padding(.vertical, 8)
            }
            .padding(.horizontal, 4)
            .frame(maxWidth: .infinity)
            .frame(height: geometry.size.height / CGFloat(days.count / 7))
          }
        }
      }
    }
  }
}

extension PocketCalenderView {
  func dayLabelColor(week: Int, item: PBCalenderItem) -> Color {
    if item.isToday { return .white }
    if week == 1 {
      return PBColors.red.color
        .opacity(item.isInCurrentMonth ? 1 : 0.3)
    } else {
      return PBColors.navy._900.color
        .opacity(item.isInCurrentMonth ? 1 : 0.3)
    }
  }
}

#Preview {
  PocketCalenderView(seletedDate: Calendar.current.date(from: DateComponents(year: 2025, month: 5))!)
    .environmentObject(PBCalenderManager())
    .environmentObject(PBFormatter())
}
