//
//  PBSelectableCircleView.swift
//  PBDesignSystem
//
//  Created by 이시원 on 3/26/25.
//

import SwiftUI

public struct PBSelectableCircleView<Content: View>: View {
  private let isSelected: Bool
  private let content: () -> Content
  
  public init(isSelected: Bool, @ViewBuilder content: @escaping () -> Content) {
    self.isSelected = isSelected
    self.content = content
  }
  
  public var body: some View {
    ZStack {
      Circle()
        .stroke(
          isSelected ? PBColors.yellow._500.color : Color.clear,
          lineWidth: 2
        )
        .frame(width: 42, height: 42)
      content()
    }
  }
}

#Preview {
  PBSelectableCircleView(isSelected: false, content: {
    
  })
}
