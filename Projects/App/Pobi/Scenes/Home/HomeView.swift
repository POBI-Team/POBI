//
//  HomeView.swift
//  Pobi
//
//  Created by 이시원 on 2/21/25.
//

import SwiftUI

import PBDesignSystem
import PBStorage
import PBStorageInterface
import LocalNotiService

import ComposableArchitecture

struct HomeView: View {
  @EnvironmentObject private var profileStorage: ProfileStorage
  @State private var selectedTabIndex: Int = 0
  @Binding private var isPresentedCreate: Bool
  //@State private var isPresentedUpdateGuide: Bool = false
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
          profileImageType.profileImage
            .resizable()
            .frame(width: 48, height: 48)
        }
        
        PBSegmentView(
          selected: $selectedTabIndex, items: .init("내 포켓"), .init("템플릿")
        )
      }
      .padding(.leading, 4)
      PocketList(selectedTabIndex: selectedTabIndex)
    }
    .toolbar(.hidden)
    .padding(.horizontal, 24)
    .fullScreenCover(isPresented: $isPresentedCreate) {
      NavigationStack {
        CreatePocketView(
          store: Store(initialState: CreatePocketFeature.State(pocket: nil)) {
            CreatePocketFeature()
          }
        )
      }
    }
//    .fullScreenCover(isPresented: $isPresentedUpdateGuide) {
//      PBNavigationBar {
//        WebView(url:"https://furry-gruyere-f25.notion.site/1-1-0-21c0c2771f6d80f0a7f5eb638ab0f16d?source=copy_link")
//      }
//      .title("업데이트 안내")
//      .rightItem {
//        Button {
//          isPresentedUpdateGuide = false
//        } label: {
//          PBImages.cancel.image
//        }
//      }
//    }
    .onAppear {
      self.profileImageType = profileStorage.loadProfileImageType() ?? .first
      self.nickname = profileStorage.loadNickname() ?? "사용자"
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
    .environmentObject(ProfileStorage())
    .environmentObject(NotificationManager())
}
