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
  
  init(isPresentedCreate: Binding<Bool>) {
    self._isPresentedCreate = isPresentedCreate
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      VStack(alignment: .leading, spacing: 4) {
        HStack {
          Text("\(ProfileStorage.shared.loadNickname() ?? "사용자")의 포켓")
            .font(PBFonts.headline._1.font)
            .padding(.top, 29)
            .padding(.bottom, 20)
          Spacer()
          NavigationLink {
            MyPageView()
              .modelContext(modelContext)
          } label: {
            ZStack(alignment: .bottomTrailing) {
              if let image = ProfileStorage.shared.loadProfileImageType()?.profileImage {
                image
                  .resizable()
                  .frame(width: 48, height: 48)
              } else {
                Circle()
                  .fill(Color.gray)
                  .frame(width: 48, height: 48)
              }
             
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
      Task {
        try await LocalNotiCenter.shared.requestAuthorization(options: [.alert, .sound])
      }
    }
  }
}

#Preview {
  HomeView(isPresentedCreate: .constant(false))
}
