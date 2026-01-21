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
import NetworkService

import ComposableArchitecture
import Feather

struct HomeView: View {
  @EnvironmentObject private var profileStorage: ProfileStorage
  @EnvironmentObject private var pocketStorage: PocketStorage
  @State private var selectedTabIndex: Int = 0
  @Binding private var isPresentedCreate: Bool
  @State private var isAppear = false
  @State private var profileImageType: ProfileImageType = .first
  @State private var nickname: String = ""
  @State private var banner: PBBanner?
  @State private var isPresentedAlert: Bool = false
  
  init(isPresentedCreate: Binding<Bool>) {
    self._isPresentedCreate = isPresentedCreate
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      VStack(alignment: .center, spacing: 4) {
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
        
        if let banner, !banner.url.isEmpty, let url = URL(string: banner.url) {
          Link(destination: banner.link) {
            FTImage()
              .setImageURL(url, isDownsampling: false) {
                ProgressView()
                  .frame(width: 335, height: 68)
              }
              .frame(width: 335, height: 68)
          }
          .padding(.bottom, 16)
        }
        
        HStack {
          PBSegmentView(
            selected: $selectedTabIndex, items: .init("내 포켓"), .init("템플릿")
          )
          Spacer()
        }
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
    .onAppear {
      isPresentedAlert = pocketStorage.initializationError != nil
    }
    .pbAlert(isPresented: $isPresentedAlert, type: .error(message: pocketStorage.initializationError?.localizedDescription ?? ""))
//    .fullScreenCover(isPresented: $isPresentedWebView) {
//      if let banner {
//        PBNavigationBar {
//          WebView(url: banner.link)
//        }
//        .title("업데이트 안내")
//        .rightItem {
//          Button {
//            isPresentedWebView = false
//          } label: {
//            PBImages.cancel.image
//          }
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
        banner = try await NetworkClient.shared.request(
          target: FirebaseAPI.banner,
          of: PBBanner.self
        )
      }
      isAppear = true
    }
  }
}

#Preview {
  HomeView(isPresentedCreate: .constant(false))
    .environmentObject(ProfileStorage())
    .environmentObject(NotificationManager())
}
