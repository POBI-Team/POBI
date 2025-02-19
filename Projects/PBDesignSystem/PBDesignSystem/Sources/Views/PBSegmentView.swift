//
//  PBSegmentView.swift
//  PBDesignSystem
//
//  Created by 이시원 on 2/19/25.
//

import SwiftUI

public struct PBSegmentItem {
  let title: String
  let action: () -> Void
  
  public init(title: String, action: @escaping () -> Void) {
    self.title = title
    self.action = action
  }
}

public struct PBSegmentView: View {
  private let items: [PBSegmentItem]
  @State private var selected: Int = 0
  
  public init(_ items: PBSegmentItem...) {
    self.items = items
  }
  
  public var body: some View {
    HStack(spacing: 8) {
      ForEach(items.indices, id: \.self) { i in
        Button {
          if selected == i { return }
          selected = i
          items[i].action()
        } label: {
          Text(items[i].title)
            .font(PBFonts.caption._1.font)
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .background(selected == i ? PBColors.navy._900.color : PBColors.list.gray._03.color)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .foregroundStyle(selected == i ? PBColors.list.gray._03.color : PBColors.navy._200.color)
      }
    }
  }
}

#Preview {
  PBSegmentView(
      .init(
        title: "전체",
        action: {}
      ),
      .init(
        title: "내 포켓",
        action: {}
      ),
      .init(
        title: "공유 포켓",
        action: {}
      )
  )
}
