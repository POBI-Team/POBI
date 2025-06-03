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
  @State private var currentDate: Date = .now
  @State private var isPresentedDatePicker: Bool = false
  
  var body: some View {
      HStack(spacing: 15) {
        Text(dateLabel)
          .font(PBFonts.headline._1.font)
          .foregroundStyle(PBColors.navy._900.color)
          .padding(.leading, 4)
        PBShapes.arrow(direction: isPresentedDatePicker ? .bottom : .right)
          .frame(width: 12, height: 6)
          .foregroundStyle(PBColors.navy._900.color)
        Spacer()
        Circle()
          .frame(width: 40, height: 40)
          .foregroundStyle(PBColors.yellow._50.color)
          .overlay {
            PBShapes.plus(lineWidth: 2.2)
              .frame(width: 18, height: 18)
              .foregroundStyle(PBColors.yellow._600.color)
          }
      }
      .animation(.default.speed(2), value: isPresentedDatePicker)
      .onTapGesture {
        isPresentedDatePicker = true
      }
      .frame(height: 80)
      .padding(.horizontal, 20)
      .sheet(isPresented: $isPresentedDatePicker) {
        YearAndMonthPickerView(seletedDate: $currentDate)
      }
    PocketCalendarView(seletedDate: $currentDate)
      .padding(.horizontal, 9)
  }
}

private extension ScheduleView {
  var dateLabel: String {
    formatter.label(currentDate, format: "MMMM YYYY", locale: Locale(identifier: "ko_kr"))
  }
}

#Preview {
  ScheduleView()
    .environmentObject(PBCalendarManager())
    .environmentObject(PBFormatter())
}
