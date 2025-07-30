//
//  RepeatsSelectView.swift
//  Pobi
//
//  Created by 이시원 on 3/10/25.
//

import SwiftUI

import PBDesignSystem
import PBStorageInterface

struct RepeatsSelectView: View {
  enum Weekday: Int, CaseIterable, CustomStringConvertible {
    case mon = 2
    case tues = 3
    case wednes = 4
    case thurs = 5
    case fri = 6
    case satur = 7
    case sun = 1
    
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
  @Binding private var alarm: Alarm
  private let gridColumns = [
    GridItem(spacing: 0),
    GridItem(spacing: 0),
    GridItem(spacing: 0),
    GridItem(spacing: 0),
    GridItem(spacing: 0),
    GridItem(spacing: 0),
    GridItem(spacing: 0)
  ]
  
  init(alarm: Binding<Alarm>) {
    self._alarm = alarm
    self.selectedTabIndex = alarm.wrappedValue.isWeekRepeat ? 0 : 1
    if alarm.wrappedValue.isWeekRepeat {
      self.selectedWeekDays = Set(alarm.wrappedValue.days.compactMap { Weekday(rawValue: $0) })
      self.selectedDays = []
    } else {
      self.selectedDays = Set(alarm.wrappedValue.days)
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
                  .foregroundStyle(PBColors.navy._100.color)
                  .frame(width: 40, height: 40)
                  .overlay {
                    ZStack {
                      Circle()
                        .foregroundStyle(.white)
                        .frame(width: 38.5, height: 38.5)
                      Text(weekDay.description)
                        .font(PBFonts.body._4.font)
                        .foregroundColor(PBColors.navy._100.color)
                    }
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
          alarm.isWeekRepeat = false
          alarm.days = selectedDays.sorted(by: <)
        } else if selectedTabIndex == 0 {
          alarm.isWeekRepeat = true
          alarm.days = selectedWeekDays.map { $0.rawValue }.sorted(by: <)
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
    .presentationDetents([.height(450)])
  }
}

extension RepeatsSelectView {
  var isSettingButtonDisabled: Bool {
    if selectedTabIndex == 0, selectedWeekDays.isEmpty { return true }
    else if selectedTabIndex == 1, selectedDays.isEmpty { return true }
    return false
  }
}

#Preview {
  Color.white
    .sheet(isPresented: .constant(true), content: { RepeatsSelectView(alarm: .constant(.init(isWeekRepeat: true, days: [1,2,3,4,5,6,7], date: .now, time: .now)))
          
    })
}
