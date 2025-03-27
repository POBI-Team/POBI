//
//  PBSegmentView.swift
//  PBDesignSystem
//
//  Created by 이시원 on 2/19/25.
//

import SwiftUI

public struct PBSegmentView: View {
  private let items: [String]
  @Binding private var selected: Int
  
  public init(selected: Binding<Int>, items: String...) {
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
          Text(items[i])
            .font(PBFonts.caption._1.font)
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .background(selected == i ? PBColors.navy._900.color : PBColors.list.gray._03.color)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .foregroundStyle(selected == i ? PBColors.list.gray._03.color : PBColors.navy._200.color)
        .buttonStyle(PlainButtonStyle())
      }
    }
  }
}

#Preview {
  PBSegmentView(
    selected: .constant(0),
    items: "전체", "내 포켓", "공유 포켓"
  )
}
