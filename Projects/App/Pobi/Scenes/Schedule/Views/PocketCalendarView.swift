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
  @EnvironmentObject private var calendarManager: PBCalendarManager
  
  @Binding private var selectedDate: Date
  @Binding private var isPresentedCreate: Bool
  @Binding private var didTapTodayButton: UUID
  
  @State private var selectedItem: PBCalendarItem?
  @State private var currentPage = 0
  @State private var calendars: [[PBCalendarItem]] = []
  @State private var sheetHeight: CGFloat = 0
  @State private var rowHeight: CGFloat?
  @State private var columnWidth: CGFloat?
  
  @GestureState private var dragOffset: CGFloat = .zero
  
  private let totalHeight: CGFloat

  @Query(
    filter: #Predicate<PocketModel> { $0.isCalendar },
    sort: \.alarm.time
  )
  private var pockets: [PocketModel]
  
  init(
    selectedDate: Binding<Date>,
    isPresentedCreate: Binding<Bool>,
    didTapTodayButton: Binding<UUID>,
    height: CGFloat
  ) {
    self._selectedDate = selectedDate
    self._isPresentedCreate = isPresentedCreate
    self._didTapTodayButton = didTapTodayButton
    self.totalHeight = height
  }
  
  var body: some View {
    ZStack {
      Rectangle()
        .foregroundStyle(.clear)
      VStack {
        TabView(selection: $currentPage) {
          ForEach([-1,0,1], id: \.self) { page in
            VStack {
              HStack {
                ForEach(calendarManager.weekdays, id: \.self) { weekday in
                  Text(formatter.weekDay(weekday) ?? "")
                    .font(PBFonts.body._4.font)
                    .foregroundStyle(weekday == 1 ? PBColors.red.color : PBColors.navy._100.color)
                    .frame(maxWidth: .infinity)
                }
              }
              .frame(height: 31)
              .padding(.horizontal, 4)
              GeometryReader { firstReader in
                LazyVGrid(
                  columns: Array(repeating: GridItem(spacing: 0), count: 7),
                  spacing: 0
                ) {
                  if !calendars.isEmpty {
                    let calendar = calendars[page+1]
                    ForEach(calendar) { item in
                      ZStack {
                        RoundedRectangle(cornerRadius: 8)
                          .foregroundStyle(rectangleColor(item: item))
                        VStack(spacing: 0) {
                          Text("\(item.day)")
                            .font(PBFonts.label._1.font)
                            .foregroundStyle(dayLabelColor(item: item))
                          GeometryReader { secondReader in
                            ZStack(alignment: .top) {
                              DotsView(
                                width: columnWidth,
                                pockets: item.pockets
                              )
                              .frame(height: firstReader.size.height)
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
                                rowHeight = secondReader.size.height
                              }
                              
                              if columnWidth == nil {
                                columnWidth = secondReader.size.width
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
                        if item.isInCurrentMonth {
                          selectedItem = item
                          withAnimation {
                            sheetHeight = totalHeight / 2
                          }
                        }
                      }
                      .frame(maxWidth: .infinity)
                      .frame(height: firstReader.size.height / CGFloat(calendar.count / 7))
                    }
                  }
                }
              }
            }
            .onDisappear {
              if currentPage != 0 {
                selectedDate = selectedDate.moveMonth(by: currentPage)!
                let newCalendar = calendarManager.days(
                  in: selectedDate.moveMonth(by: currentPage)!,
                  with: pockets
                )
                if currentPage == 1 {
                  calendars.append(newCalendar)
                  calendars.removeFirst()
                } else {
                  calendars.insert(newCalendar, at: 0)
                  calendars.removeLast()
                }
                currentPage = 0
              }
            }
            .tag(page)
          }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(maxHeight: totalHeight)
        .frame(height: max(totalHeight/2, totalHeight - sheetHeight), alignment: .top)
        Spacer()
      }
      .onAppear {
        if calendars.isEmpty {
          setupCalendar()
        }
      }
      .fullScreenCover(isPresented: $isPresentedCreate) {
        var date: Date? = nil
        if let selectedItem {
          date = calendarManager.date(
            of: selectedItem.day,
            in: selectedDate,
            isInCurrentMonth: selectedItem.isInCurrentMonth
          )
        }
        return CreatePocketView(pocket: nil, date: date)
      }
      VStack {
        Spacer()
        PocketSheet(
          date: selectedDate,
          item: $selectedItem,
          minHeight: totalHeight/2
        )
        .id(selectedItem?.id)
        .frame(height: max(0, sheetHeight), alignment: .top)
        .background(.white)
        .clipped()
      }
    }
    .id(calendars.isEmpty)
    .onChange(of: dragOffset) { oldValue, newValue in
      if abs(newValue) > abs(oldValue) {
        sheetHeight -= (newValue - oldValue)
      }
    }
    .onChange(of: didTapTodayButton) {
      selectedDate = .now
      setupCalendar()
      selectedItem = calendars[1].first { $0.isToday }
    }
    .gesture(
      DragGesture()
        .updating($dragOffset) { value, state, _ in
          state = value.translation.height
        }
        .onEnded { _ in
          if sheetHeight < totalHeight * 0.25 {
            withAnimation {
              sheetHeight = 0
            }
          } else if sheetHeight > totalHeight * 0.75 {
            withAnimation {
              sheetHeight = totalHeight
            }
          } else {
            withAnimation {
              sheetHeight = totalHeight / 2
            }
          }
        }
    )
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
  
  func setupCalendar() {
    calendars = [
      calendarManager.days(
        in: selectedDate.moveMonth(by: -1)!,
        with: pockets
      ),
      calendarManager.days(
        in: selectedDate,
        with: pockets
      ),
      calendarManager.days(
        in: selectedDate.moveMonth(by: 1)!,
        with: pockets
      )
    ]
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
  @Previewable @State var isPresentedCreate = false
  GeometryReader {
    PocketCalendarView(
      selectedDate: $date,
      isPresentedCreate: $isPresentedCreate,
      didTapTodayButton: .constant(.init()),
      height: $0.size.height
    )
      .environmentObject(PBCalendarManager())
      .environmentObject(PBFormatter())
  }
}
