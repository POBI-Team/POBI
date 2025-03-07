//
//  PBRoundButton.swift
//  PBDesignSystem
//
//  Created by 이시원 on 3/7/25.
//

import SwiftUI

public struct PBRoundButton: View {
  private let cornerRadius: CGFloat
  private let action: () -> Void
  private var title: LocalizedStringKey
  
  
  public init(_ title: LocalizedStringKey, cornerRadius: CGFloat, action: @escaping () -> Void) {
    self.cornerRadius = cornerRadius
    self.title = title
    self.action = action
  }
  
  public var body: some View {
    Button(action: action) {
      RoundedRectangle(cornerRadius: cornerRadius)
        .overlay {
          Text(title)
            .foregroundStyle(PBColors.navy._900.color)
            .font(PBFonts.caption._1.font)
        }
    }
  }
}

#Preview {
  PBRoundButton("10월 10일", cornerRadius: 10, action: {})
}
