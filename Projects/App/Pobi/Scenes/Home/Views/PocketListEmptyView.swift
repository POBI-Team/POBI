//
//  PocketListEmptyView.swift
//  Pobi
//
//  Created by 이시원 on 3/31/25.
//

import SwiftUI

import PBDesignSystem

struct PocketListEmptyView: View {
  var body: some View {
    VStack(spacing: 40) {
      PBImages.pobiEmpty.image
      VStack(spacing: 8) {
        Text("포켓이 텅 비었어요!")
          .font(PBFonts.title._1.font)
          .foregroundStyle(PBColors.navy._900.color)
        Text("아래의 버튼을 눌러 포켓을 생성하고,\n소지품 리스트를 작성해주세요")
          .font(PBFonts.body._4.font)
          .foregroundStyle(PBColors.navy._200.color)
          .multilineTextAlignment(.center)
      }
    }
  }
}

#Preview {
  PocketListEmptyView()
}
