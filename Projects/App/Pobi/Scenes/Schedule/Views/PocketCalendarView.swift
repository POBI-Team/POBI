//
//  PocketCalendarView.swift
//  Pobi
//
//  Created by 이시원 on 4/30/25.
//

import SwiftUI

import PBCalendar
import PBDesignSystem

struct PocketCalendarView: View {
  @EnvironmentObject private var formatter: PBFormatter
  @EnvironmentObject private var calender: PBCalendarManager
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
                  .foregroundStyle(dayLabelColor(item: days[i]))
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

extension PocketCalendarView {
  func dayLabelColor(item: PBCalendarItem) -> Color {
    if item.isToday { return .white }
    if item.weekday == 1 {
      return PBColors.red.color
        .opacity(item.isInCurrentMonth ? 1 : 0.3)
    } else {
      return PBColors.navy._900.color
        .opacity(item.isInCurrentMonth ? 1 : 0.3)
    }
  }
}

#Preview {
  PocketCalendarView(seletedDate: Calendar.current.date(from: DateComponents(year: 2025, month: 5))!)
    .environmentObject(PBCalendarManager())
    .environmentObject(PBFormatter())
}
