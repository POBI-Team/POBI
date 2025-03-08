//
//  PBCapsuleButton.swift
//  PBDesignSystem
//
//  Created by 이시원 on 3/7/25.
//

import SwiftUI

public struct PBCapsuleButton: View {
  private let action: () -> Void
  private var title: LocalizedStringKey
  
  public init(_ title: LocalizedStringKey, action: @escaping () -> Void) {
    self.title = title
    self.action = action
  }
  
  public var body: some View {
    Button(action: action) {
      HStack {
        Spacer()
        Text(title)
          .font(PBFonts.body._1.font)
          .padding(.vertical, 12)
        Spacer()
      }
      .background(PBColors.navy._900.color)
      .clipShape(Capsule())
    }
  }
}

#Preview {
  PBCapsuleButton("XX", action: {})
}
