//
//  PocketTagList.swift
//  Pobi
//
//  Created by 이시원 on 6/5/25.
//

import SwiftUI

import PBDesignSystem
import PBStorageInterface
import PBCalendar

struct PocketTagList: View {
  private let rowCount: Int
  private let item: PBCalendarItem
  private let selectedItem: PBCalendarItem?
  
  init(height: CGFloat?, item: PBCalendarItem, selectedItem: PBCalendarItem?) {
    if let height {
      let c = Int(height / 21)
      if c < item.pockets.count {
        self.rowCount = c - 1
      } else {
        self.rowCount = min(c, item.pockets.count)
      }
    } else {
      self.rowCount = 0
    }
    self.item = item
    self.selectedItem = selectedItem
  }
  
  var body: some View {
    VStack(spacing: 6) {
      VStack(spacing: 4) {
        ForEach(0..<rowCount, id: \.self) { j in
          let pocket = item.pockets[j]
          CalendarTag(pocket: pocket)
        }
      }
      if rowCount < item.pockets.count {
        Text("+\(item.pockets.count - rowCount)")
          .font(PBFonts.label._3.font)
          .foregroundStyle(labelColor)
      }
    }
  }
}

private extension PocketTagList {
  var labelColor: Color {
    if item.id == selectedItem?.id {
      return PBColors.navy._50.color
    } else {
      return PBColors.navy._300.color
    }
  }
}
