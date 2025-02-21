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
    NavigationStack {
      VStack(alignment: .leading, spacing: 20) {
        VStack(alignment: .leading, spacing: 4) {
          HStack {
            Text("XXX의 포켓")
              .font(PBFonts.headline._1.font)
          }
          .padding(.vertical, 24)
          PBSegmentView(
            PBSegmentItem(title: "전체", action: {}),
            PBSegmentItem(title: "내 포켓", action: {}),
            PBSegmentItem(title: "공유 포켓", action: {})
          )
        }
        .padding(.leading, 4)
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
      .padding(.horizontal, 20)
    }
  }
}

#Preview {
  PocketList()
}
