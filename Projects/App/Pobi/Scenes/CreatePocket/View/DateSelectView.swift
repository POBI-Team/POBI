//
//  DateSelectView.swift
//  Pobi
//
//  Created by 이시원 on 7/30/25.
//

import SwiftUI

import PBStorageInterface
import PBDesignSystem

struct DateSelectView: View {
  private enum DateType {
    case start
    case end
  }
  
  @State private var selectedDate: DateType = .start
  @State private var startDate: Date
  @State private var endDate: Date
  @Binding private var pocket: Pocket
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var formatter: PBFormatter
  
  init(
    pocket: Binding<Pocket>
  ) {
    self.startDate = pocket.wrappedValue.alarm.date
    self.endDate = pocket.wrappedValue.alarm.endDate
    self._pocket = pocket
  }
  
  var body: some View {
    VStack(spacing: 0) {
      HStack(alignment: .bottom, spacing: 32) {
        VStack(spacing: 6) {
          Text("시작일")
            .foregroundStyle(PBColors.navy._300.color)
            .font(PBFonts.label._2.font)
          
          Text(startDateLabel)
            .foregroundStyle(
              selectedDate == .start ? PBColors.yellow._500.color : PBColors.navy._900.color
            )
            .font(PBFonts.subTitie._1.font)
        }
        .onTapGesture { selectedDate = .start }
        PBShapes.arrow(lineWidht: 2.5,direction: .right)
          .frame(width: 18, height: 10)
          .foregroundStyle(PBColors.navy._100.color)
          .padding(.bottom, 6)
        VStack(spacing: 6) {
          Text("종료일")
            .foregroundStyle(PBColors.navy._300.color)
            .font(PBFonts.label._2.font)
          
          Text(endDateLabel)
            .foregroundStyle(
              selectedDate == .end ? PBColors.yellow._500.color : PBColors.navy._900.color
            )
            .font(PBFonts.subTitie._1.font)
        }
        .onTapGesture { selectedDate = .end }
      }
      .padding(.top, 28)
      .padding(.bottom, 6)
      DatePicker(
        "",
        selection: Binding(
          get: { selectedDate == .start ? startDate : endDate },
          set: { setDate($0) }
        ),
        displayedComponents: .date
      )
      .padding(.horizontal, 20)
      .labelsHidden()
      .tint(PBColors.yellow._500.color)
      .datePickerStyle(.graphical)
      .environment(\.locale, Locale(identifier: Locale.preferredLanguages[0]))
      Spacer()
      PBRoundButton(16) {
        pocket.alarm.date = startDate
        pocket.alarm.endDate = endDate
        dismiss()
      } label: {
        Text("설정")
          .foregroundStyle(.white)
          .font(PBFonts.body._1.font)
      }
      .foregroundStyle(PBColors.navy._900.color)
      .frame(height: 52)
      .padding(.horizontal, 20)
    }
    .presentationCornerRadius(30)
    .presentationDetents([.height(510)])
  }
}

private extension DateSelectView {
  var startDateLabel: String {
    formatter.label(startDate, format: "YY년 MM월 dd일")
  }
  
  var endDateLabel: String {
    formatter.label(endDate, format: "YY년 MM월 dd일")
  }
  
  func setDate(_ date: Date) {
    if selectedDate == .start {
      if date > endDate {
        endDate = date
      }
      startDate = date
    } else {
      if date < startDate {
        startDate = date
      }
      endDate = date
    }
  }
}

#Preview {
  @Previewable @State var pocket = Pocket()
  
  Color.white
    .sheet(isPresented: .constant(true), content: {
      DateSelectView(pocket: $pocket)
        .environmentObject(PBFormatter())
    })
}
