//
//  PBSegmentView.swift
//  PBDesignSystem
//
//  Created by 이시원 on 2/19/25.
//

import SwiftUI

public struct PBSegmentView: View {
  public struct Item {
    let icon: String?
    let title: String
    
    public init(_ title: String, icon: String? = nil) {
      self.icon = icon
      self.title = title
    }
  }
  private let items: [Item]
  private var seletedColor: Color = PBColors.navy._900.color
  private var unSelectedColor: Color = PBColors.list.gray._03.color
  @Binding private var selected: Int
  
  public init(selected: Binding<Int>, items: Item...) {
    self.items = items
    self._selected = selected
  }
  
  public init(selected: Binding<Int>, items: [Item]) {
    self.items = items
    self._selected = selected
  }
  
  public var body: some View {
    HStack(spacing: 8) {
      ForEach(items.indices, id: \.self) { i in
        Button {
          if selected == i { return }
          selected = i
        } label: {
          HStack(spacing: 8) {
            if let icon = items[i].icon {
              Text(icon)
                .font(PBFonts.tossFace.small.font)
            }
            Text(items[i].title)
              .font(PBFonts.caption._1.font)
          }
          .padding(.horizontal, items[i].icon != nil ? 14 : 16)
          .padding(.vertical, items[i].icon != nil ? 8 : 7)
          .frame(height: items[i].icon != nil ? 40 : 36)
          .background(selected == i ? seletedColor : unSelectedColor)
          .clipShape(Capsule())
        }
        .foregroundStyle(selected == i ? PBColors.list.gray._03.color : PBColors.navy._200.color)
        .buttonStyle(.plain)
      }
    }
  }
}

public extension PBSegmentView {
  func seletedColor(_ color: Color) -> Self {
    var view = self
    view.seletedColor = color
    return view
  }
  
  func unSelectedColor(_ color: Color) -> Self {
    var view = self
    view.unSelectedColor = color
    return view
  }
}

#Preview {
  PBSegmentView(
    selected: .constant(0),
    items: .init("전체"), .init("숨김", icon: "✏️")
  )
  //.unSelectedColor(.clear)
}
