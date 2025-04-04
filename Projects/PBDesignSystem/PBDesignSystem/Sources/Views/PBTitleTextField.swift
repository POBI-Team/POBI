//
//  PBTitleTextField.swift
//  PBDesignSystem
//
//  Created by 이시원 on 3/4/25.
//

import SwiftUI

struct DottedLine: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: CGPoint(x: rect.minX, y: rect.midY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
    return path
  }
}

struct PBTextFieldModifier: ViewModifier {
  @Binding private var text: String
  
  init(text: Binding<String>) {
    self._text = text
  }
  
  func body(content: Content) -> some View {
    VStack(spacing: 8) {
      content
        .multilineTextAlignment(.center)
        .font(PBFonts.body._1.font)
      DottedLine()
        .stroke(
          style: StrokeStyle(
            lineWidth: 2,
            dash: text.isEmpty ? [2,2] : [1,0]
          )
        )
        .foregroundColor(PBColors.navy._50.color)
        .frame(height: 1)
    }
  }
}

extension View {
  public func underLine(text: Binding<String>) -> some View {
    modifier(PBTextFieldModifier(text: text))
  }
}

