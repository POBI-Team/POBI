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
  @EnvironmentObject var notificationManager: NotificationManager
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
        CreatePocketView(.create, pocket: .init())
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
