//
//  CompleteView.swift
//  Pobi
//
//  Created by 이시원 on 4/1/25.
//

import SwiftUI

import PBStorage
import PBDesignSystem

struct CompleteView: View {
  @EnvironmentObject private var profileStorage: ProfileStorage
  @State private var isPresentedHome = false
  @State private var isPresentedCreate = false
  
  var body: some View {
    VStack(spacing: 0) {
      Spacer()
      Text("🎉")
        .font(PBFonts.tossFace.xlarge.font)
        .padding(.bottom, 42)
      Text("\(profileStorage.loadNickname() ?? "")님, 반가워요!")
        .font(PBFonts.headline._1.font)
        .foregroundStyle(PBColors.navy._900.color)
      Spacer()
      PBRoundButton(16) {
        NotificationCenter.default.post(name: .createPocket, object: nil)
      } label: {
        Text("포켓 만들기")
          .foregroundStyle(.white)
          .font(PBFonts.button._1.font)
      }
      .frame(height: 52)
      .padding(.horizontal, 20)
      .padding(.bottom, 19)
      .foregroundStyle(PBColors.navy._900.color)
      Button {
        NotificationCenter.default.post(name: .skip, object: nil)
      } label: {
        Text("건너뛰기")
          .font(PBFonts.button._2.font)
          .foregroundStyle(PBColors.navy._300.color)
      }
    }
    .toolbar(.hidden)
    .padding(.bottom, 12)
  }
}

#Preview {
  CompleteView()
}
