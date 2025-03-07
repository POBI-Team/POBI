//
//  PBAlarmSegmentControl.swift
//  PBDesignSystem
//
//  Created by 이시원 on 3/7/25.
//

import SwiftUI

public struct PBAlarmSegmentControl: View {
  @State var isRepeated: Bool = false
  private let action: (Bool) -> Void
  
  public init(action: @escaping (_ isRepeated: Bool) -> Void) {
    self.action = action
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
              action(isRepeated)
            } label: {
              Text("일회성")
                .font(PBFonts.body._2.font)
            }
            .foregroundStyle(PBColors.navy._900.color)
            Spacer()
            Button {
              isRepeated = true
              action(isRepeated)
            } label: {
              Text("반복성")
                .font(PBFonts.body._2.font)
            }
            .foregroundStyle(PBColors.navy._900.color)
          }
          .padding(.horizontal, 22)
        }
        .padding(4)
      }
  }
}

#Preview {
  PBAlarmSegmentControl(action: {_ in})
}
