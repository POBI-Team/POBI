//
//  DateSelectView.swift
//  Pobi
//
//  Created by 이시원 on 7/30/25.
//

import SwiftUI

import PBDesignSystem

struct DateSelectView: View {
  var body: some View {
    VStack {
      HStack(alignment: .bottom, spacing: 32) {
        VStack(spacing: 6) {
          Text("시작")
            .foregroundStyle(PBColors.navy._300.color)
            .font(PBFonts.label._2.font)
          
          Text("25년 7월 23일")
            .foregroundStyle(PBColors.navy._900.color)
            .font(PBFonts.subTitie._1.font)
        }
        PBShapes.arrow(lineWidht: 2.5,direction: .right)
          .frame(width: 18, height: 10)
          .foregroundStyle(PBColors.navy._100.color)
          .padding(.bottom, 6)
        VStack(spacing: 6) {
          Text("종료")
            .foregroundStyle(PBColors.navy._300.color)
            .font(PBFonts.label._2.font)
          
          Text("25년 7월 23일")
            .foregroundStyle(PBColors.navy._900.color)
            .font(PBFonts.subTitie._1.font)
        }
      }
      .padding(.top, 22)
      DatePicker(
        "",
        selection: .constant(.now),
        displayedComponents: .date
      )
      .padding(.horizontal, 20)
      .labelsHidden()
      .tint(PBColors.yellow._500.color)
      .datePickerStyle(.graphical)
      .environment(\.locale, Locale(identifier: Locale.preferredLanguages[0]))
      
      PBRoundButton(16) {

      } label: {
        Text("설정")
          .foregroundStyle(.white)
          .font(PBFonts.body._1.font)
      }
      .foregroundStyle(PBColors.navy._900.color)
      .frame(height: 52)
      .padding(.horizontal, 20)
      .padding(.top, 10)
    }
    .presentationCornerRadius(30)
    .presentationDetents([.height(550)])
  }
}

#Preview {
  Color.white
    .sheet(isPresented: .constant(true), content: {
      DateSelectView()
    })
}
