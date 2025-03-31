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
    VStack(alignment: .leading, spacing: 20) {
      VStack(alignment: .leading, spacing: 4) {
        HStack {
          Text("XXX의 포켓")
            .font(PBFonts.headline._1.font)
            .padding(.top, 29)
            .padding(.bottom, 20)
          Spacer()
          NavigationLink {
            MyPageView()
          } label: {
            ZStack(alignment: .bottomTrailing) {
              Circle()
                .fill(Color.gray)
                .frame(width: 48, height: 48)
              Circle()
                .overlay {
                  PBImages.settingFill.image
                }
                .foregroundStyle(PBColors.navy._10.color)
                .frame(width: 24, height: 24)
                .padding([.bottom, .trailing], -8)
            }
          }
          .buttonStyle(.plain)
        }
        PBSegmentView(
          selected: $seletedTabIndex, items: .init("전체"), .init("숨긴 포켓")
        )
      }
      .padding(.leading, 4)
      PocketList()
    }
    .padding(.horizontal, 24)
  }
}

#Preview {
  HomeView()
}
