//
//  ProfileSettingView.swift
//  Pobi
//
//  Created by 이시원 on 4/1/25.
//

import SwiftUI

import PBDesignSystem
import PBStorage

struct ProfileSettingView: View {
  @State private var nickname: String = ""
  @State private var profileTpye: ProfileImageType = .first
  @State private var isPresnetedComplete: Bool = false
  
  var body: some View {
    VStack {
      Spacer()
      Text("프로필 설정")
        .font(PBFonts.headline._1.font)
        .foregroundStyle(PBColors.navy._900.color)
        .padding(.bottom, 41)
      HStack(spacing: 20) {
        Button {
          profileTpye = .first
        } label: {
          PBImages.profileFirst.image
            .grayscale(profileTpye == .first ? 0.0 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        
        Button {
          profileTpye = .second
        } label: {
          PBImages.profileSecond.image
            .grayscale(profileTpye == .second ? 0.0 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        
      }
      .padding(.bottom, 36)
      PBTitleTextField(
        text: $nickname,
        placeholder: "별명을 입력해주세요!"
      )
      .padding(.horizontal, 44)
      Spacer()
      PBRoundButton(16) {
        ProfileStorage.shared.saveNotFirstEntry()
        ProfileStorage.shared.saveNickname(nickname)
        ProfileStorage.shared.saveProfileImageType(profileTpye)
        isPresnetedComplete = true
      } label: {
        Text("다음")
          .foregroundStyle(.white)
          .font(PBFonts.button._1.font)
      }
      .frame(height: 52)
      .padding(.horizontal, 20)
      .padding(.bottom, 12)
      .foregroundStyle(PBColors.navy._900.color)
      .navigationDestination(isPresented: $isPresnetedComplete) {
        CompleteView()
      }
    }
    .toolbar(.hidden)
  }
}

#Preview {
  ProfileSettingView()
}
