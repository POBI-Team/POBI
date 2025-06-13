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
  @State private var selectedTabIndex: Int = 0
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
    .environmentObject(NotificationManager())
}
