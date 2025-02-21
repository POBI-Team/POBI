//
//  PBPlusButton.swift
//  PBDesignSystem
//
//  Created by 이시원 on 2/21/25.
//

import SwiftUI

public struct PBPlusButton: View {
  private let action: () -> Void
  
  public init(action: @escaping () -> Void) {
    self.action = action
  }
  
  public var body: some View {
    Button {
      action()
    } label: {
      Circle()
        .frame(width: 61, height: 61)
        .foregroundStyle(PBColors.navy._900.color)
        .overlay {
          PBImages.plus.image
        }
    }
  }
}

#Preview {
  PBPlusButton(action: {})
}
