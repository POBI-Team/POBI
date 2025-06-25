//
//  ScheduleView.swift
//  Pobi
//
//  Created by 이시원 on 4/29/25.
//

import SwiftUI

import PBDesignSystem
import PBCalendar

struct ScheduleView: View {
  @EnvironmentObject private var formatter: PBFormatter
  @EnvironmentObject private var calendarManager: PBCalendarManager

  @State private var selectedDate: Date = .now
  @State private var isPresentedDatePicker: Bool = false
  @State private var isPresentedCreate: Bool = false
  @State private var didTapTodayButton = UUID()
  @State private var didTapPickerFinishButton = UUID()
  
  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 12) {
        HStack(spacing: 15) {
          Text(dateLabel)
            .font(PBFonts.headline._1.font)
            .foregroundStyle(PBColors.navy._900.color)
            .padding(.leading, 4)
          PBShapes.arrow(direction: isPresentedDatePicker ? .bottom : .right)
            .animation(.default.speed(2), value: isPresentedDatePicker)
            .frame(width: 12, height: 6)
            .foregroundStyle(PBColors.navy._900.color)
        }
        .onTapGesture {
          isPresentedDatePicker = true
        }
        Spacer()
        
        if !isCurrentMonth {
          Button {
            selectedDate = .now
            didTapTodayButton = UUID()
          } label: {
            Capsule()
              .stroke(lineWidth: 1.4)
              .foregroundStyle(PBColors.navy._50.color)
              .frame(width: 73, height: 38)
              .overlay {
                HStack(spacing: 4) {
                  PBImages.return.image
                  Text("오늘")
                    .font(PBFonts.caption._2.font)
                    .foregroundStyle(PBColors.navy._900.color)
                }
              }
          }
          .buttonStyle(.plain)
        }
        
        Button {
          isPresentedCreate = true
        } label: {
          Circle()
            .frame(width: 40, height: 40)
            .foregroundStyle(PBColors.navy._900.color)
            .overlay {
              PBShapes.plus(lineWidth: 2.2)
                .frame(width: 18, height: 18)
                .foregroundStyle(.white)
            }
        }
        .buttonStyle(.plain)
      }
      .frame(height: 80)
      .padding(.horizontal, 20)
      GeometryReader { reader in
        PocketCalendarView(
          selectedDate: $selectedDate,
          isPresentedCreate: $isPresentedCreate,
          didTapTodayButton: $didTapTodayButton,
          didTapPicketFinishButton: $didTapPickerFinishButton,
          height: reader.size.height
        )
        .padding(.horizontal, 9)
      }
    }
    .sheet(isPresented: $isPresentedDatePicker) {
      YearAndMonthPickerView(
        selectedDate: $selectedDate,
        didTapPickerFinishButton: $didTapPickerFinishButton
      )
    }
  }
}

private extension ScheduleView {
  var dateLabel: String {
    formatter.label(selectedDate, format: "MMMM YYYY", locale: Locale(identifier: "ko_kr"))
  }
  
  var isCurrentMonth: Bool {
    Calendar.current.isDate(
      selectedDate,
      equalTo: .now,
      toGranularity: .month
    )
  }
}

#Preview {
  ScheduleView()
    .environmentObject(PBCalendarManager())
    .environmentObject(PBFormatter())
}
