//
//  DotsView.swift
//  Pobi
//
//  Created by 이시원 on 6/7/25.
//

import SwiftUI

import PBDesignSystem
import PBStorageInterface
import PBCalendar

struct DotsView: View {
  private let item: PBCalendarItem
  private let dotLimit: Int
  
  init(width: CGFloat?, item: PBCalendarItem) {
    self.item = item
    self.dotLimit = Int(((width ?? 0)+4)/10)
  }
  
  var body: some View {
    HStack(alignment: .center, spacing: 4) {
      ForEach(0..<min(dotLimit, item.pockets.count), id: \.self) { i in
        RoundedRectangle(cornerRadius: 1)
          .foregroundStyle(PBColors.list.colors[Int(item.pockets[i].colorIndex)]._02.color)
          .frame(width: 6, height: 6)
      }
    }
  }
}
