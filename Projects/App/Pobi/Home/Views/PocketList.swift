//
//  PocketList.swift
//  Pobi
//
//  Created by 이시원 on 2/15/25.
//

import SwiftUI

import PBDesignSystem

struct PocketList: View {
  var body: some View {
    ScrollView {
      LazyVGrid(
        columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible())],
        spacing: 15
      ) {
        PocketCell(listColor: PBColors.list.blue.self)
        PocketCell(listColor: PBColors.list.yellow.self)
        PocketCell(listColor: PBColors.list.mint.self)
        PocketCell(listColor: PBColors.list.pink.self)
        PocketCell(listColor: PBColors.list.blue.self)
        PocketCell(listColor: PBColors.list.yellow.self)
        PocketCell(listColor: PBColors.list.mint.self)
        PocketCell(listColor: PBColors.list.pink.self)
        PocketCell(listColor: PBColors.list.blue.self)
        PocketCell(listColor: PBColors.list.yellow.self)
        PocketCell(listColor: PBColors.list.mint.self)
        PocketCell(listColor: PBColors.list.pink.self)
      }
    }
    .scrollIndicators(.hidden)
    .overlay(alignment: .bottom) {
      PBPlusButton(action: {})
    }
  }
}

#Preview {
  PocketList()
}
