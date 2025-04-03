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
  @Environment(\.dismiss) private var dismiss
  @State private var seletedTabIndex = 0
  @State private var selectedWeekDays: Set<String> = []
  @State private var selectedDays: Set<Int> = []
  @Binding private var date: String
  
  private let days = ["월", "화", "수", "목", "금", "토", "일"]
  private let gridColumns = [
    GridItem(spacing: 0),
    GridItem(spacing: 0),
    GridItem(spacing: 0),
    GridItem(spacing: 0),
    GridItem(spacing: 0),
    GridItem(spacing: 0),
    GridItem(spacing: 0)
  ]
  
  init(date: Binding<String>) {
    guard !date.wrappedValue.isEmpty else { self._date = date; return }
    let splitedDate = date.wrappedValue.split(separator: " ", maxSplits: 1)
    self.seletedTabIndex = splitedDate[0] == "매월" ? 1 : 0
    if splitedDate[0] == "매월" {
      self.selectedDays = Set(splitedDate[1].split(separator: ", ").compactMap { Int($0) })
      
    } else if splitedDate[0] == "매일" {
      self.selectedWeekDays = Set(days)
    } else {
      self.selectedWeekDays = Set(splitedDate[1].split(separator: ", ").map { String($0) })
    }
    self._date = date
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Capsule()
        .frame(width: 36, height: 5)
        .padding(.bottom, 27)
        .foregroundStyle(PBColors.navy._50.color)
      PBSegmentView(selected: $seletedTabIndex, items: .init("매주"), .init("매월"))
      if seletedTabIndex == 1 {
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
          ForEach(days.indices, id: \.self) { i in
            Button {
              if selectedWeekDays.contains(days[i]) {
                selectedWeekDays.remove(days[i])
                return
              }
              selectedWeekDays.insert(days[i])
            } label: {
              if selectedWeekDays.contains(days[i]) {
                Circle()
                  .foregroundStyle(PBColors.yellow._500.color)
                  .frame(width: 40, height: 40)
                  .overlay {
                    Text(days[i])
                      .font(PBFonts.body._4.font)
                      .foregroundColor(.white)
                  }
              } else {
                Circle()
                  .stroke(PBColors.navy._100.color, lineWidth: 1)
                  .frame(width: 40, height: 40)
                  .overlay {
                    Text(days[i])
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
        if seletedTabIndex == 1, !selectedDays.isEmpty {
          if selectedDays.count == 31 {
            date = "매일"
          } else {
            date = "매월 " + (1...31)
              .filter { selectedDays.contains($0) }
              .map { String($0) }
              .joined(separator: ", ")
          }
        } else if seletedTabIndex == 0, !selectedWeekDays.isEmpty {
          if selectedWeekDays.count == 7 {
            date = "매일"
          } else {
            date = "매주 " + days
              .filter { selectedWeekDays.contains($0) }
              .joined(separator: ", ")
          }
        } else {
          date = ""
        }
        dismiss()
      } label: {
        Text("설정")
          .foregroundStyle(.white)
          .font(PBFonts.body._1.font)
      }
      .foregroundStyle(PBColors.navy._900.color)
      .frame(height: 48)
    }
    .padding(.top, 5)
    .padding(.horizontal, 20)
  }
}

#Preview {
  DateSelectView(date: .constant("매일"))
}
