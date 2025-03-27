//
//  PBRoundButton.swift
//  PBDesignSystem
//
//  Created by 이시원 on 3/7/25.
//

import SwiftUI

public struct PBRoundButton<Label: View>: View {
  private let cornerRadius: CGFloat
  private let action: () -> Void
  private var label:  () -> Label
  
  public init(
    _ cornerRadius: CGFloat,
    action: @escaping () -> Void,
    @ViewBuilder label: @escaping () -> Label
  ) {
    self.cornerRadius = cornerRadius
    self.action = action
    self.label = label
  }
  
  public var body: some View {
    Button(action: action) {
      RoundedRectangle(cornerRadius: cornerRadius)
        .overlay {
          label()
        }
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  PBRoundButton(10, action: {}, label: { Text("Hello") })
}
