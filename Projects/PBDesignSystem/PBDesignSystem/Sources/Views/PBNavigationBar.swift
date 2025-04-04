//
//  PBNavigationBar.swift
//  PBDesignSystem
//
//  Created by 이시원 on 3/28/25.
//

import SwiftUI

public struct PBNavigationBar<Content: View>: View {
  private var content:  () -> Content
 
  private var leftItem: AnyView?
  private var rightItem: AnyView?
  private var title: String? = nil
  
  public init(
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.content = content
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      HStack {
        leftItem
        Spacer()
        rightItem
      }
      .padding(.horizontal, 20)
      .background(.white)
      .frame(height: 48)
      .overlay {
        if let title {
          Text(title)
            .foregroundStyle(PBColors.navy._900.color)
            .font(PBFonts.title._1.font)
        }
      }
      content()
    }
    .background(.white)
    .toolbar(.hidden)
  }
}

extension PBNavigationBar {
  public func title(_ title: String) -> Self {
    var newView = self
    newView.title = title
    return newView
  }
  
  public func leftItem<T: View>(@ViewBuilder _ content: @escaping () -> T) -> Self {
    var newView = self
    newView.leftItem = AnyView(content())
    return newView
  }
  
  public func rightItem<T: View>(@ViewBuilder _ content: @escaping () -> T) -> Self {
    var newView = self
    newView.rightItem = AnyView(content())
    return newView
  }
}

#Preview {
  PBNavigationBar {
    Color.blue
  }
  .title("XX")
  .leftItem {
    Button("Left") {
      print(1)
    }
  }
  .rightItem {
    Button("Right") {
      print(1)
    }
  }
}
