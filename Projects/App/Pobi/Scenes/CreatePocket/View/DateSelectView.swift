//
//  DateSelectView.swift
//  Pobi
//
//  Created by 이시원 on 3/10/25.
//

import SwiftUI

import PBDesignSystem
import PBStorageInterface

struct DateSelectView: View {
  enum Weekday: Int, CaseIterable, CustomStringConvertible {
    case mon = 1
    case tues
    case wednes
    case thurs
    case fri
    case satur
    case sun
    
    var description: String {
      switch self {
      case .mon: "월"
      case .tues: "화"
      case .wednes: "수"
      case .thurs: "목"
      case .fri: "금"
      case .satur: "토"
      case .sun: "일"
      }
    }
  }
  
  
  @Environment(\.dismiss) private var dismiss
  @State private var selectedTabIndex: Int
  @State private var selectedWeekDays: Set<Weekday>
  @State private var selectedDays: Set<Int>
    
  private let pocket: PocketModel
  private let gridColumns = [
    GridItem(spacing: 0),
    GridItem(spacing: 0),
    GridItem(spacing: 0),
    GridItem(spacing: 0),
    GridItem(spacing: 0),
    GridItem(spacing: 0),
    GridItem(spacing: 0)
  ]
  
  init(pocket: PocketModel) {
    self.pocket = pocket
    self.selectedTabIndex = pocket.alarm.isWeekRepeat ? 0 : 1
    if pocket.alarm.isWeekRepeat {
      self.selectedWeekDays = Set(pocket.alarm.days.compactMap { Weekday(rawValue: $0) })
      self.selectedDays = []
    } else {
      self.selectedDays = Set(pocket.alarm.days)
      self.selectedWeekDays = []
    }
  }
  
  var body: some View {
    VStack(spacing: 0) {
      PBSegmentView(selected: $selectedTabIndex, items: .init("매주"), .init("매월"))
      if selectedTabIndex == 1 {
        LazyVGrid(columns: gridColumns) {
          ForEach(1...31, id: \.self) { day in
            Button {
              if selectedDays.contains(day) {
                selectedDays.remove(day)
                return
              }
              selectedDays.insert(day)
            } label: {
              Circle()
                .foregroundStyle(
                  selectedDays.contains(day) ? PBColors.yellow._500.color : Color.clear
                )
                .frame(width: 40, height: 40)
                .overlay {
                  Text("\(day)")
                    .font(PBFonts.body._1.font)
                    .foregroundColor(
                      selectedDays.contains(day) ? .white : PBColors.navy._900.color
                    )
                }
            }
            .buttonStyle(PlainButtonStyle())
          }
        }
        .frame(height: 246)
        .background(PBColors.navy._10.color)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.top, 24)
        
      } else {
        HStack {
          ForEach(Weekday.allCases, id: \.self) { weekDay in
            Button {
              if selectedWeekDays.contains(weekDay) {
                selectedWeekDays.remove(weekDay)
                return
              }
              selectedWeekDays.insert(weekDay)
            } label: {
              if selectedWeekDays.contains(weekDay) {
                Circle()
                  .foregroundStyle(PBColors.yellow._500.color)
                  .frame(width: 40, height: 40)
                  .overlay {
                    Text(weekDay.description)
                      .font(PBFonts.body._4.font)
                      .foregroundColor(.white)
                  }
              } else {
                Circle()
                  .stroke(PBColors.navy._100.color, lineWidth: 1)
                  .frame(width: 40, height: 40)
                  .overlay {
                    Text(weekDay.description)
                      .font(PBFonts.body._4.font)
                      .foregroundColor(PBColors.navy._100.color)
                  }
              }
            }
            .buttonStyle(PlainButtonStyle())
          }
        }
        .padding(.top, 28)
      }
      Spacer()
      PBRoundButton(16) {
        if selectedTabIndex == 1 {
          pocket.alarm.isWeekRepeat = false
          pocket.alarm.days = selectedDays.sorted(by: <)
        } else if selectedTabIndex == 0 {
          pocket.alarm.isWeekRepeat = true
          pocket.alarm.days = selectedWeekDays.map { $0.rawValue }.sorted(by: <)
        }
        dismiss()
      } label: {
        Text("설정")
          .foregroundStyle(.white)
          .font(PBFonts.body._1.font)
      }
      .disabled(isSettingButtonDisabled)
      .foregroundStyle(PBColors.navy._900.color)
      .frame(height: 48)
    }
    .padding(.top, 24)
    .padding(.horizontal, 20)
    .presentationCornerRadius(30)
    .presentationDetents([.medium])
  }
}

extension DateSelectView {
  var isSettingButtonDisabled: Bool {
    if selectedTabIndex == 0, selectedWeekDays.isEmpty { return true }
    else if selectedTabIndex == 1, selectedDays.isEmpty { return true }
    return false
  }
}

#Preview {
  Color.white
    .sheet(isPresented: .constant(true), content: { DateSelectView(pocket: .init())
          
    })
}
