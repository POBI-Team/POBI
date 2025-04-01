//
//  PBTitleTextField.swift
//  PBDesignSystem
//
//  Created by 이시원 on 3/4/25.
//

import SwiftUI

public struct PBTitleTextField: View {
  struct DottedLine: Shape {
    func path(in rect: CGRect) -> Path {
      var path = Path()
      path.move(to: CGPoint(x: rect.minX, y: rect.midY))
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
      return path
    }
  }
  
  @Binding public var text: String
  @FocusState private var isFocused: Bool
  private let placeholder: String
  
  public init(text: Binding<String>, placeholder: String) {
    self._text = text
    self.placeholder = placeholder
  }
  
  public var body: some View {
    TextField(placeholder, text: $text)
      .multilineTextAlignment(.center)
      .font(PBFonts.body._1.font)
      .focused($isFocused)
      .onAppear {
        isFocused = true
      }
    
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

#Preview {
  PBTitleTextField(text: .constant(""), placeholder: "플레이스 홀더")
}
