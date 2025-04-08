//
//  SettingAlarmView.swift
//  Pobi
//
//  Created by 이시원 on 4/8/25.
//

import SwiftUI

import PBDesignSystem
import PBStorageInterface

struct SettingAlarmView: View {
  @State private var isSelectedDate = false
  @State private var isSelectedTime = false
  @State private var isPresentedDataSelectView = false
  @Binding private var pocket: Pocket
  @Binding private var isDidTapDownButton: Bool
  @FocusState private var isFocused: Bool
  
  init(
    pocket: Binding<Pocket>,
    isFocused: FocusState<Bool>,
    isDidTapDownButton: Binding<Bool>
  ) {
    self._pocket = pocket
    self._isFocused = isFocused
    self._isDidTapDownButton = isDidTapDownButton
  }
  
  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      PBAlarmSegmentControl(
        isRepeated: $pocket.repeats
      )
      .padding(.bottom, 20)
      HStack {
        Text(pocket.repeats ? "반복" : "날짜")
          .font(PBFonts.body._2.font)
          .foregroundStyle(PBColors.navy._900.color)
        Spacer()
        if pocket.repeats {
          Button {
            isPresentedDataSelectView.toggle()
          } label: {
            HStack(spacing: 8) {
              Spacer()
              Text(repeatLabel)
                .font(PBFonts.caption._1.font)
                .foregroundStyle(PBColors.navy._300.color)
                .lineLimit(1)
                .frame(maxWidth: 150, alignment: .trailing)
              PBImages.right.image
            }
            .frame(height: 34)
          }
        } else {
          PBRoundButton(10) {
            withAnimation(.default.speed(1.5)) {
              isSelectedDate.toggle()
              isDidTapDownButton = false
              isSelectedTime = false
              isFocused = false
            }
          } label: {
            Text(dateLabel)
              .font(PBFonts.caption._1.font)
              .foregroundStyle(PBColors.navy._900.color)
          }
          .frame(width: 84, height: 34)
          .foregroundStyle(PBColors.navy._50.color)
        }
      }
      .padding(.horizontal, 20)
      .padding(.bottom, 8)
      
      VStack(spacing: 0) {
        if isSelectedDate {
          Divider()
        }
        DatePicker(
          "",
          selection: $pocket.alarm.date,
          displayedComponents: .date
        )
        .frame(height: isSelectedDate ? nil : 0, alignment: .top)
        .tint(PBColors.yellow._500.color)
        .datePickerStyle(.graphical)
        .environment(\.locale, Locale(identifier: Locale.preferredLanguages[0]))
        if isSelectedDate {
          Divider()
        }
      }
      .padding(.horizontal, 20)
      .disabled(!isSelectedDate)
      .clipped()
      
      HStack {
        Text("시간")
          .foregroundStyle(PBColors.navy._900.color)
          .font(PBFonts.body._2.font)
        Spacer()
        PBRoundButton(10) {
          withAnimation(.default.speed(1.5)) {
            isSelectedTime.toggle()
            isDidTapDownButton = false
            isFocused = false
            isSelectedDate = false
          }
        } label: {
          Text(timeLabel)
            .font(PBFonts.caption._1.font)
            .foregroundStyle(PBColors.navy._900.color)
        }
        .frame(width: 84, height: 34)
        .foregroundStyle(PBColors.navy._50.color)
      }
      .padding(.top, 8)
      .padding(.horizontal, 20)

      
      VStack(alignment: .center, spacing: 0) {
        if isSelectedTime {
          Divider()
            .padding(.top, 8)
            .padding(.horizontal, 20)
        }
        
        DatePicker(
          "",
          selection: $pocket.alarm.time,
          displayedComponents: .hourAndMinute
        )
        .datePickerStyle(.wheel)
        .frame(height: isSelectedTime ? nil : 0, alignment: .top)
      }
      .disabled(!isSelectedTime)
      .clipped()
    }
    .padding(.vertical, 16)
    .background(.white)
    .clipShape(RoundedRectangle(cornerRadius: 20))
    .onChange(of: pocket.repeats, { _, _ in
      withAnimation {
        isSelectedDate = false
      }
    })
    .onChange(of: isDidTapDownButton, { _, new in
      guard new else { return }
      withAnimation {
        isSelectedDate = false
        isSelectedTime = false
      }
    })
    .sheet(isPresented: $isPresentedDataSelectView) {
      DateSelectView(
        alarm: Binding(get: { pocket.alarm }, set: { pocket.alarm = $0 })
      )
    }
  }
}

private extension SettingAlarmView {
  var repeatLabel: String {
    PBFormatter.shared.label(isWeekDay: pocket.alarm.isWeekRepeat, days: pocket.alarm.days)
  }
  
  var timeLabel: String {
    PBFormatter.shared.label(pocket.alarm.time, format: "h:mm a")
  }
  
  var dateLabel: String {
    PBFormatter.shared.label(pocket.alarm.date, format: "M월 d일")
  }
}

#Preview {
  @Previewable @FocusState var isFocused: Bool

  SettingAlarmView(
    pocket: .constant(.init()),
    isFocused: _isFocused,
    isDidTapDownButton: .constant(false)
  )
}
