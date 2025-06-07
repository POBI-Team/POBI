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
  @State private var selectedItem: PBCalendarItem?
  @State private var currentPage = 0
  @State private var totalHeight: CGFloat = 0
  @State private var sheetHeight: CGFloat = 0
  @State private var calendarMinHeight: CGFloat = 0
  
  @State private var rowHeight: CGFloat?
  @State private var columnWidth: CGFloat?
  
  #if DEBUG
  private var pockets: [PocketModel] = [
    PocketModel(
      title: "test1",
      alarm: .init(
        isWeekRepeat: false,
        days: [],
        date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 4))!,
        time: .now
      )
    ),
    PocketModel(
      title: "test2",
      alarm: .init(
        isWeekRepeat: false,
        days: [],
        date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 4))!,
        time: .now
      )
    ),
    PocketModel(
      title: "test3",
      alarm: .init(
        isWeekRepeat: false,
        days: [],
        date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 4))!,
        time: .now
      )
    ),
    PocketModel(
      title: "test4",
      alarm: .init(
        isWeekRepeat: false,
        days: [],
        date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 4))!,
        time: .now
      )
    ),
    PocketModel(
      title: "test5",
      alarm: .init(
        isWeekRepeat: false,
        days: [],
        date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 4))!,
        time: .now
      )
    ),
    PocketModel(
      title: "test6",
      alarm: .init(
        isWeekRepeat: false,
        days: [],
        date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 4))!,
        time: .now
      )
    )
  ]
  #else
  @Query(
    filter: #Predicate<PocketModel> { $0.isCalendar },
    sort: \.alarm.time.secondsSinceStartOfDay
  )
  private var pockets: [PocketModel]
  #endif
  init(seletedDate: Binding<Date>) {
    self._selectedDate = seletedDate
  }
  
  var body: some View {
    GeometryReader { fristGeometry in
      ZStack {
        Rectangle()
          .foregroundStyle(.clear)
        VStack {
          TabView(selection: $currentPage) {
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
                GeometryReader { secondGeometry in
                  LazyVGrid(
                    columns: Array(repeating: GridItem(spacing: 0), count: 7),
                    spacing: 0
                  ) {
                    let days = calender.days(in: targetDate, with: pockets)
                    ForEach(days) { item in
                      ZStack {
                        RoundedRectangle(cornerRadius: 8)
                          .foregroundStyle(rectangleColor(item: item))
                        VStack(spacing: 0) {
                          Text("\(item.day)")
                            .font(PBFonts.label._1.font)
                            .foregroundStyle(dayLabelColor(item: item))
                          GeometryReader { thirdGeometry in
                            ZStack(alignment: .top) {
                              DotsView(
                                width: columnWidth,
                                pockets: item.pockets
                              )
                              .frame(height: thirdGeometry.size.height)
                              .opacity(sheetHeight/(totalHeight/2))
                              
                              PocketTagList(
                                height: rowHeight,
                                item: item,
                                selectedItem: selectedItem
                              )
                              .padding(.top, 4)
                              .opacity(1.0 - (sheetHeight/(totalHeight/2)))
                            }
                            .onAppear {
                              if rowHeight == nil {
                                rowHeight = thirdGeometry.size.height
                              }
                              
                              if columnWidth == nil {
                                columnWidth = thirdGeometry.size.width
                              }
                            }
                          }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 4)
                      }
                      .onAppear {
                        if selectedItem == nil, item.isToday {
                          selectedItem = item
                        }
                      }
                      .onTapGesture {
                        selectedItem = item
                        withAnimation {
                          sheetHeight = fristGeometry.size.height / 2
                        }
                      }
                      .frame(maxWidth: .infinity)
                      .frame(height: secondGeometry.size.height / CGFloat(days.count / 7))
                    }
                  }
                }
              }
              .tag(i)
              .onDisappear {
                if currentPage != 0 {
                  selectedDate = selectedDate.moveMonth(by: currentPage)!
                  currentPage = 0
                }
              }
            }
          }
          .tabViewStyle(.page(indexDisplayMode: .never))
          .frame(height: max(calendarMinHeight, totalHeight - sheetHeight), alignment: .top)
          
          Spacer()
        }
        VStack {
          Spacer()
          PocketSheet(
            date: selectedDate,
            height: $sheetHeight,
            item: $selectedItem,
            totalHeight: fristGeometry.size.height
          )
          .frame(height: max(0, sheetHeight), alignment: .top)
          .background(.white)
          .clipped()
        }
      }
      .onAppear {
        totalHeight = fristGeometry.size.height
        calendarMinHeight = fristGeometry.size.height / 2
      }
    }
  }
}

private extension PocketCalendarView {
  func dayLabelColor(item: PBCalendarItem) -> Color {
    if let selectedItem, item.id == selectedItem.id { return .white }
    if item.isToday { return PBColors.navy._900.color }
    if item.weekday == 1 {
      return PBColors.red.color
        .opacity(item.isInCurrentMonth ? 1 : 0.3)
    } else {
      return PBColors.navy._900.color
        .opacity(item.isInCurrentMonth ? 1 : 0.3)
    }
  }
  
  func rectangleColor(item: PBCalendarItem) -> Color {
    if let selectedItem, item.id == selectedItem.id { return PBColors.navy._900.color }
    else if item.isToday { return PBColors.yellow._50.color }
    else { return .white }
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
  @Previewable @State var date = Calendar.current.date(from: DateComponents(year: 2025, month: 6))!
  
  PocketCalendarView(seletedDate: $date)
    .environmentObject(PBCalendarManager())
    .environmentObject(PBFormatter())
}
