//
//  CalendarTag.swift
//  Pobi
//
//  Created by 이시원 on 5/16/25.
//

import SwiftUI

import PBDesignSystem

import PBStorageInterface

struct CalendarTag: View {
  private let pocket: PocketModel
  
  init(pocket: PocketModel) {
    self.pocket = pocket
  }
  
  var body: some View {
    HStack {
      Text(pocket.title)
        .lineLimit(1)
        .font(PBFonts.label._2.font)
        .foregroundStyle(PBColors.navy._900.color)
      Spacer()
    }
    .padding(.vertical, 2)
    .padding(.horizontal, 6)
    .background(PBColors.list.colors[pocket.colorIndex]._02.color)
    .clipShape(RoundedRectangle(cornerRadius: 4))
  }
}

#Preview {
  CalendarTag(pocket: .init(title: "이름"))
    .frame(width: 43)
}
