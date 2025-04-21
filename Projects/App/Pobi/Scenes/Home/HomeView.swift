//
//  HomeView.swift
//  Pobi
//
//  Created by 이시원 on 2/21/25.
//

import SwiftUI

import PBDesignSystem
import PBStorage
import LocalNotiService

struct HomeView: View {
  @Environment(\.modelContext) private var modelContext
  @State private var seletedTabIndex: Int = 0
  @Binding private var isPresentedCreate: Bool
  @State private var isAppear = false
  @State private var profileImageType: ProfileImageType = .first
  @State private var nickname: String = ""
  
  init(isPresentedCreate: Binding<Bool>) {
    self._isPresentedCreate = isPresentedCreate
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      VStack(alignment: .leading, spacing: 4) {
        HStack {
          Text("\(nickname)의 포켓")
            .font(PBFonts.headline._1.font)
            .foregroundStyle(PBColors.navy._900.color)
            .padding(.top, 29)
            .padding(.bottom, 20)
          Spacer()
          NavigationLink {
            MyPageView()
              .modelContext(modelContext)
          } label: {
            ZStack(alignment: .bottomTrailing) {
              profileImageType.profileImage
                .resizable()
                .frame(width: 48, height: 48)
             
              Circle()
                .overlay {
                  PBImages.settingFill.image
                }
                .foregroundStyle(PBColors.navy._10.color)
                .frame(width: 28, height: 28)
                .padding(.trailing, -8)
                .padding(.bottom, -10)
            }
          }
          .buttonStyle(.plain)
        }
        Link(destination: URL(string: "https://forms.gle/3jtXR98eGkbmpdpT8")!) {
          HStack {
            VStack(alignment: .leading, spacing: 3) {
              HStack(spacing: 4) {
                Text("📢")
                  .font(PBFonts.tossFace.xsmall.font)
                Text("소지품 리셋 어떻게 쓰고 계세요?")
                  .font(PBFonts.label._1.font)
                  .foregroundStyle(PBColors.navy._900.color)
              }
              Text("포비를 위해 설문에 참여해주세요!")
                .font(PBFonts.label._2.font)
                .foregroundStyle(PBColors.navy._200.color)
            }
            Spacer()
            Text("참여하기")
              .font(PBFonts.button._4.font)
              .foregroundStyle(.white)
              .frame(width: 62, height: 28)
              .background(PBColors.navy._300.color)
              .clipShape(RoundedRectangle(cornerRadius: 8))
              
          }
          .padding(.horizontal, 20)
          .frame(height: 68)
          .background(PBColors.navy._10.color)
          .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.top, 4)
        .padding(.bottom, 20)
        .buttonStyle(.plain)
        PBSegmentView(
          selected: $seletedTabIndex, items: .init("내 포켓"), .init("숨긴 포켓")
        )
      }
      .padding(.leading, 4)
      PocketList(seletedTabIndex: seletedTabIndex)
    }
    .toolbar(.hidden)
    .padding(.horizontal, 24)
    .fullScreenCover(isPresented: $isPresentedCreate) {
      NavigationStack {
        CreatePocketView(pocket: nil)
      }
    }
    .onAppear {
      self.profileImageType = ProfileStorage.shared.loadProfileImageType() ?? .first
      self.nickname = ProfileStorage.shared.loadNickname() ?? "사용자"
    }
    .onAppear {
      guard !isAppear else { return }
      Task {
        try await LocalNotiCenter.shared.requestAuthorization(options: [.alert, .sound])
        isAppear = true
      }
    }
  }
}

#Preview {
  HomeView(isPresentedCreate: .constant(false))
}
