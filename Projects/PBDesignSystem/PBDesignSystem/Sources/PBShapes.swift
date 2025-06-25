//
//  PBShapes.swift
//  PBDesignSystem
//
//  Created by 이시원 on 4/29/25.
//

import SwiftUI

public struct PBShapes {
  public enum Direction {
    case top
    case bottom
    case left
    case right
    
    var angle: Angle {
      switch self {
      case .top:
        return .init(degrees: 0)
      case .bottom:
        return .init(degrees: 180)
      case .left:
        return .init(degrees: 270)
      case .right:
        return .init(degrees: 90)
      }
    }
  }
  public static func plus(lineWidth: CGFloat = 2) -> some Shape {
    PlusShape()
      .stroke(style: .init(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
  }
  
  public static func arrow(lineWidht: CGFloat = 2, direction: Direction) -> some View {
    ArrowShape()
      .stroke(style: .init(lineWidth: lineWidht, lineCap: .round, lineJoin: .round))
      .rotationEffect(direction.angle)
  }
}

struct PlusShape: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: .init(x: rect.midX, y: rect.minY))
    path.addLine(to: .init(x: rect.midX, y: rect.maxY))
    path.move(to: .init(x: rect.minX, y: rect.midY))
    path.addLine(to: .init(x: rect.maxX, y: rect.midY))
    return path
  }
}

struct ArrowShape: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: .init(x: rect.minX, y: rect.maxY))
    path.addLine(to: .init(x: rect.midX, y: rect.minY))
    path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
    return path
  }
}
