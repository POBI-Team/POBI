//
//  PBAlarmSegmentControl.swift
//  PBDesignSystem
//
//  Created by 이시원 on 3/7/25.
//

import SwiftUI

public struct PBAlarmSegmentControl: View {
  @Binding private var isRepeated: Bool
  
  public init(isRepeated: Binding<Bool>) {
    self._isRepeated = isRepeated
  }
  
  public var body: some View {
    Capsule()
      .frame(width: 184, height: 40)
      .foregroundStyle(PBColors.navy._50.color)
      .overlay {
        HStack {
          if isRepeated { Spacer() }
          Capsule()
            .frame(width: 87, height: 32)
            .foregroundStyle(.white)
          if !isRepeated { Spacer() }
        }
        .animation(.easeOut, value: isRepeated)
        .overlay {
          HStack {
            Button {
              isRepeated = false
            } label: {
              Text("일회성")
                .font(PBFonts.body._2.font)
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundStyle(PBColors.navy._900.color)
            Spacer()
            Button {
              isRepeated = true
            } label: {
              Text("반복성")
                .font(PBFonts.body._2.font)
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundStyle(PBColors.navy._900.color)
          }
          .padding(.horizontal, 22)
        }
        .padding(4)
      }
  }
}

#Preview {
  PBAlarmSegmentControl(isRepeated: .constant(false))
}
