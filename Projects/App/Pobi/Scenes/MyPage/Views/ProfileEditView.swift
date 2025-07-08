//
//  ProfileEditView.swift
//  Pobi
//
//  Created by 이시원 on 4/1/25.
//

import SwiftUI

import PBDesignSystem
import PBStorage
import PBStorageInterface

struct ProfileEditView: View {
  @EnvironmentObject private var profileStorage: ProfileStorage
  @State private var profileType: ProfileImageType?
  @State private var nickname: String = ""
  @Environment(\.dismiss) private var dismiss
  @FocusState private var isFocused: Bool
  
  var body: some View {
    PBNavigationBar {
      VStack {
        HStack(spacing: 20) {
          Button {
            isFocused = false
            profileType = .first
          } label: {
            PBImages.profileFirst.image
              .grayscale(profileType == .first ? 0.0 : 1.0)
          }
          .buttonStyle(PlainButtonStyle())
          
          Button {
            isFocused = false
            profileType = .second
          } label: {
            PBImages.profileSecond.image
              .grayscale(profileType == .second ? 0.0 : 1.0)
          }
          .buttonStyle(PlainButtonStyle())
        }
        .padding(.top, 32)
        .padding(.bottom, 36)
        TextField(
          "별명을 입력해주세요! (7자 이내)",
          text: Binding {
            nickname
          } set: {
            nickname = $0.trimmingCharacters(in: .whitespaces)
          }
        )
        .onChange(of: nickname) { oldValue, newValue in
          if newValue.count > 7 {
            nickname = oldValue
          }
        }
        .focused($isFocused)
        .underLine(text: $nickname)
      }
      .padding(.horizontal, 44)
      .onTapGesture {
        isFocused = false
      }
      .onAppear {
        profileType = profileStorage.loadProfileImageType()
        nickname = profileStorage.loadNickname() ?? ""
      }
      
      Spacer()
      PBRoundButton(16) {
        profileStorage.saveNickname(nickname)
        profileStorage.saveProfileImageType(profileType ?? .first)
        dismiss()
      } label: {
        Text("프로필 설정하기")
          .foregroundStyle(.white)
          .font(PBFonts.button._1.font)
      }
      .disabled(nickname.isEmpty)
      .frame(height: 52)
      .padding(.horizontal, 20)
      .padding(.bottom, 12)
      .foregroundStyle(PBColors.navy._900.color)
      
    }
    .title("마이페이지")
    .leftItem {
      Button {
        dismiss()
      } label: {
        PBImages.left.image
      }
    }
  }
}

#Preview {
  ProfileEditView()
    .environmentObject(ProfileStorage())
}
