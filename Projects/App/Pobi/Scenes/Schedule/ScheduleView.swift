//
//  ScheduleView.swift
//  Pobi
//
//  Created by 이시원 on 4/29/25.
//

import SwiftUI

import PBDesignSystem

struct ScheduleView: View {
  var body: some View {
      HStack(spacing: 15) {
        Text("3월 2025")
          .font(PBFonts.headline._1.font)
          .foregroundStyle(PBColors.navy._900.color)
          .padding(.leading, 4)
        PBShapes.arrow(direction: .right)
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
      .frame(height: 80)
      .padding(.horizontal, 20)
    PocketCalenderView()
      .padding(.horizontal, 9)
  }
}

#Preview {
  ScheduleView()
}
