//
//  HomeView.swift
//  Pobi
//
//  Created by 이시원 on 2/21/25.
//

import SwiftUI

import PBDesignSystem

struct HomeView: View {
  @State private var seletedTabIndex: Int = 0
  
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
            selected: $seletedTabIndex, items: "전체", "내 포켓", "공유 포켓"
          )
        }
        .padding(.leading, 4)
        PocketList()
      }
      .padding(.horizontal, 20)
    }
  }
}

#Preview {
    HomeView()
}
