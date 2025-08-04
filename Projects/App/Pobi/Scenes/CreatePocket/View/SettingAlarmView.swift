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
  @State private var isSelectedTime = false
  @State private var isPresentedRepeatsSelectView = false
  @State private var isPresentedDateSelectView = false

  @Binding private var pocket: Pocket
  @Binding private var isDidTapDownButton: Bool
  @FocusState private var isFocused: Bool
  @EnvironmentObject private var formatter: PBFormatter
  
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
        Button {
          if pocket.repeats {
            isPresentedRepeatsSelectView.toggle()
          } else {
            withAnimation(.default.speed(1.5)) {
              isPresentedDateSelectView.toggle()
              isDidTapDownButton = false
              isSelectedTime = false
              isFocused = false
            }
          }
        } label: {
          HStack(spacing: 8) {
            Spacer()
            Text(pocket.repeats ? repeatLabel : dateLabel)
              .font(PBFonts.caption._1.font)
              .foregroundStyle(PBColors.navy._300.color)
              .lineLimit(1)
              .frame(maxWidth: 250, alignment: .trailing)
            PBImages.right.image
          }
          .frame(height: 34)
        }
      }
      .padding(.horizontal, 20)
      .padding(.bottom, 8)
      
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
        
        HStack {
          DatePicker(
            "",
            selection: $pocket.alarm.time,
            displayedComponents: .hourAndMinute
          )
          .labelsHidden()
          .datePickerStyle(.wheel)
        }
        .frame(height: isSelectedTime ? nil : 0, alignment: .top)
      }
      .disabled(!isSelectedTime)
      .clipped()
    }
    .padding(.vertical, 16)
    .background(.white)
    .clipShape(RoundedRectangle(cornerRadius: 20))
    .onChange(of: isDidTapDownButton, { _, new in
      guard new else { return }
      withAnimation {
        isSelectedTime = false
      }
    })
    .sheet(isPresented: $isPresentedRepeatsSelectView) {
      RepeatsSelectView(
        alarm: Binding(get: { pocket.alarm }, set: { pocket.alarm = $0 })
      )
    }
    .sheet(isPresented: $isPresentedDateSelectView) {
      DateSelectView(pocket: $pocket)
    }
  }
}

private extension SettingAlarmView {
  var repeatLabel: String {
    formatter.label(isWeekDay: pocket.alarm.isWeekRepeat, days: pocket.alarm.days)
  }
  
  var timeLabel: String {
    formatter.label(pocket.alarm.time, format: "h:mm a")
  }
  
  var dateLabel: String {
    formatter.alarmLabel(pocket.alarm.date, endDate: pocket.alarm.endDate)
  }
}

#Preview {
  @Previewable @FocusState var isFocused: Bool
  @Previewable @State var pocket = Pocket()
  
  SettingAlarmView(
    pocket: $pocket,
    isFocused: _isFocused,
    isDidTapDownButton: .constant(false)
  )
  .environmentObject(PBFormatter())
}
