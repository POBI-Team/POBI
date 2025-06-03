//
//  PocketCalendarView.swift
//  Pobi
//
//  Created by 이시원 on 4/30/25.
//

import SwiftUI
import SwiftData

import PBStorageInterface
import PBCalendar
import PBDesignSystem

struct PocketCalendarView: View {
  @EnvironmentObject private var formatter: PBFormatter
  @EnvironmentObject private var calender: PBCalendarManager
  @Binding private var selectedDate: Date
  @Query(
    filter: #Predicate<PocketModel> { $0.isCalendar },
    sort: \.alarm.time.secondsSinceStartOfDay
  )
  private var pockets: [PocketModel]
  @State private var offset = 0
  
  init(seletedDate: Binding<Date>) {
    self._selectedDate = seletedDate
  }
  
  var body: some View {
    TabView(selection: $offset) {
      ForEach([-1,0,1], id: \.self) { i in
        let targetDate = selectedDate.moveMonth(by: i)!
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
              let days = calender.days(in: targetDate, with: pockets)
              ForEach(days) { item in
                ZStack {
                  if item.isToday {
                    RoundedRectangle(cornerRadius: 8)
                  }
                  VStack(spacing: 4) {
                    Text("\(item.day)")
                      .font(PBFonts.label._1.font)
                      .foregroundStyle(dayLabelColor(item: item))
                    GeometryReader { geometry in
                      let rowCount = rowCount(height: geometry.size.height, count: item.pockets.count)
                      VStack(alignment: .leading, spacing: 6) {
                        VStack(spacing: 4) {
                          ForEach(0..<rowCount, id: \.self) { j in
                            let pocket = item.pockets[j]
                            CalendarTag(pocket: pocket)
                          }
                        }
                        if rowCount < item.pockets.count {
                          Text("+\(item.pockets.count - rowCount)")
                            .font(PBFonts.label._3.font)
                            .foregroundStyle(PBColors.navy._50.color)
                        }
                      }
                    }
                  }
                  .padding(.vertical, 8)
                  .padding(.horizontal, 4)
                }
                .frame(maxWidth: .infinity)
                .frame(height: geometry.size.height / CGFloat(days.count / 7))
              }
            }
          }
        }
        .tag(i)
        .onDisappear {
          if offset != 0 {
            selectedDate = selectedDate.moveMonth(by: offset)!
            offset = 0
          }
        }
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
  }
}

private extension PocketCalendarView {
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
  
  func rowCount(height: Double, count: Int) -> Int {
    let c = Int(height / 21)
    if c < count { return c - 1 }
    else { return min(c, count) }
  }
}

private extension Date {
  var secondsSinceStartOfDay: TimeInterval {
    return timeIntervalSince(Calendar.current.startOfDay(for: self))
  }
  
  func moveMonth(by value: Int) -> Date? {
    return Calendar.current.date(byAdding: .month, value: value, to: self)
  }
}

#Preview {
  @Previewable @State var date = Calendar.current.date(from: DateComponents(year: 2025, month: 5))!
  
  PocketCalendarView(seletedDate: $date)
    .environmentObject(PBCalendarManager())
    .environmentObject(PBFormatter())
}
