//
//  DateSelectView.swift
//  Pobi
//
//  Created by 이시원 on 3/10/25.
//

import SwiftUI

import PBDesignSystem

struct DateSelectView: View {
  @State private var isSelectedEveryMonth = false
  @State private var selectedDays: Set<String> = []
  @State private var selectedDay: Int?
  
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
  
  var body: some View {
    VStack(spacing: 0) {
      PBSegmentView(
        PBSegmentItem(title: "매주", action: { isSelectedEveryMonth = false }),
        PBSegmentItem(title: "매월", action: { isSelectedEveryMonth = true })
      )
      .padding(.bottom, 28)
      if isSelectedEveryMonth {
        RoundedRectangle(cornerRadius: 8)
          .fill(PBColors.navy._10.color)
          .frame(height: 246)
          .overlay {
            LazyVGrid(
              columns: gridColumns) {
                ForEach(1...31, id: \.self) { day in
                  Button {
                    selectedDay = day
                  } label: {
                    Circle()
                      .foregroundStyle(
                        selectedDay == day ? PBColors.yellow._500.color : Color.clear
                      )
                      .frame(width: 40, height: 40)
                      .overlay {
                        Text("\(day)")
                          .font(PBFonts.body._2.font)
                          .foregroundColor(
                            selectedDay == day ? .white : PBColors.navy._900.color
                          )
                      }
                  }
                  .buttonStyle(PlainButtonStyle())
                }
              }
          }
          
      } else {
        HStack {
          ForEach(days.indices, id: \.self) { i in
            Button {
              if selectedDays.contains(days[i]) {
                selectedDays.remove(days[i])
                return
              }
              selectedDays.insert(days[i])
            } label: {
              if selectedDays.contains(days[i]) {
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
      }
      Spacer()
      PBRoundButton(16) {
        
      } label: {
        Text("설정")
          .foregroundStyle(.white)
          .font(PBFonts.body._1.font)
      }
      .foregroundStyle(PBColors.navy._900.color)
      .frame(height: 48)
    }
    .padding(.horizontal, 20)
  }
}

#Preview {
  DateSelectView()
}
