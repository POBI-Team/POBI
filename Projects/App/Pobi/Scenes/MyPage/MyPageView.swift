//
//  MyPageView.swift
//  Pobi
//
//  Created by 이시원 on 3/28/25.
//

import SwiftUI
import SwiftData

import PBStorage
import PBDesignSystem
import PBStorageInterface
import LocalNotiService

struct MyPageView: View {
  @Environment(\.modelContext) private var modelContext
  @EnvironmentObject private var profileStorage: ProfileStorage
  @State private var isPresentAlert: Bool = false
  @State private var profileImage: Image?
  @State private var nickname: String?

  var body: some View {
    PBNavigationBar {
      VStack(spacing: 20) {
        ZStack(alignment: .bottomTrailing) {
          if let image = profileImage {
            image
              .resizable()
              .frame(width: 120, height: 120)
          } else {
            Circle()
              .fill(Color.gray)
              .frame(width: 120, height: 120)
          }
          NavigationLink {
            ProfileEditView()
          } label: {
            Circle()
              .overlay {
                PBImages.pen.image
              }
          }
          .buttonStyle(.plain)
          .foregroundStyle(PBColors.navy._900.color)
          .frame(width: 36, height: 36)
          .padding(.bottom, -4)
        }
        Text(nickname ?? "")
          .padding(.bottom, 12)
          .font(PBFonts.title._1.font)
        Group {
          VStack(spacing: 24) {
            Group {
              ShareLink(item: URL(string: "https://apps.apple.com/app/id6744066403")!) {
                HStack {
                  PBImages.like.image
                  Text("친구에게 포비 추천하기")
                    .font(PBFonts.button._3.font)
                    .foregroundStyle(PBColors.navy._900.color)
                  Spacer()
                  PBImages.right.image
                }
              }
              Link(destination: URL(string: "https://furry-gruyere-f25.notion.site/21c0c2771f6d806da953d8ff76c9789a?source=copy_link")!) {
                HStack {
                  PBImages.speaker.image
                  Text("공지사항")
                    .font(PBFonts.button._3.font)
                    .foregroundStyle(PBColors.navy._900.color)
                  Spacer()
                  PBImages.right.image
                }
              }
              Link(destination: URL(string: "itms-apps://itunes.apple.com/app/6744066403")!) {
                HStack {
                  PBImages.mail.image
                  Text("앱스토어 리뷰 쓰기")
                    .font(PBFonts.button._3.font)
                    .foregroundStyle(PBColors.navy._900.color)
                  Spacer()
                  PBImages.right.image
                }
              }
              Button {
                isPresentAlert.toggle()
              } label: {
                HStack {
                  Group {
                    PBImages.trash.image
                    Text("모든 포켓 초기화")
                      .font(PBFonts.button._3.font)
                  }
                  .foregroundStyle(PBColors.red.color)
                  Spacer()
                }
              }
            }
            .padding(.horizontal, 16)
          }
          .scrollDisabled(true)
          .padding(.vertical, 16)
          .background(.white)
          
          HStack {
            VStack(alignment: .leading, spacing: 12) {
              Text("포비에게 궁금한 점이 있다면\n언제든 연락주세요!")
                .lineSpacing(3)
                .font(PBFonts.body._4.font)
                .foregroundStyle(PBColors.navy._900.color)
                .padding(.horizontal, 20)
              Link(destination: URL(string: "https://pf.kakao.com/_LHHxfn")!) {
                Capsule()
                  .frame(width: 133, height: 40)
                  .foregroundStyle(PBColors.yellow._50.color)
                  .padding(.horizontal, 16)
                  .overlay {
                    Text("포비에게 카톡하기")
                      .font(PBFonts.label._1.font)
                      .foregroundStyle(PBColors.yellow._700.color)
                  }
              }
            }
            Spacer()
            PBImages.pobiInquiry.image
          }
          .background(.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        Spacer()

      }
      .padding(.top, 36)
      .padding(.horizontal, 20)
      .background(PBColors.navy._10.color)
      .onAppear {
        profileImage = profileStorage.loadProfileImageType()?.profileImage
        nickname = profileStorage.loadNickname()
      }
      .pbAlert(isPresented: $isPresentAlert, type: .deleteAll) {
        LocalNotiCenter.shared.removeAll()
        try? modelContext.fetch(FetchDescriptor<PocketModel>())
          .forEach({ pocket in
            modelContext.delete(pocket)
          })
        try? modelContext.fetch(FetchDescriptor<TemplateModel>())
          .forEach({ template in
            modelContext.delete(template)
          })
        try? modelContext.save()
      }
    }
    .title("마이페이지")
  }
}

#Preview {
  MyPageView()
    .environmentObject(ProfileStorage())
}
