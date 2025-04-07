//
//  PBCircleEmojiView.swift
//  PBDesignSystem
//
//  Created by 이시원 on 2/21/25.
//

import SwiftUI

public struct PBCircleEmojiView: View {
  public enum Size {
    case small
    case medium
    case large
    case xlarge
  }
  
  private let emoji: String?
  private let size: Size
  public init(_ emoji: String?, size: Size) {
    self.emoji = emoji
    self.size = size
  }
  
  private var circleDiameter: CGFloat {
      switch size {
      case .small: 36
      case .medium: 40
      case .large: 60
      case .xlarge: 80
      }
  }
  
  private var emojiSize: CGFloat {
      switch size {
      case .small: 24
      case .medium: 26
      case .large, .xlarge: 40
      }
  }
  
  private var emojiFont: Font {
      switch size {
      case .small: PBFonts.tossFace.small.font
      case .medium: PBFonts.tossFace.medium.font
      case .large, .xlarge: PBFonts.tossFace.large.font
      }
  }
  
  public var body: some View {
    Circle()
      .frame(width: circleDiameter, height: circleDiameter)
      .overlay {
        if let emoji {
          Text(emoji)
            .font(emojiFont)
            .frame(width: emojiSize, height: emojiSize)
        } else {
          ProgressView()
        }
      }
  }
}

#Preview {
  PBCircleEmojiView("😄", size: .small)
}
