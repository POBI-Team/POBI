//
//  MyPageView.swift
//  Pobi
//
//  Created by 이시원 on 3/28/25.
//

import SwiftUI

import PBDesignSystem

struct MyPageView: View {
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    PBNavigationBar {
      VStack(spacing: 20) {
        ZStack(alignment: .bottomTrailing) {
          Circle()
            .fill(Color.gray)
            .frame(width: 120, height: 120)
          Button {
            
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
        Text("XXX")
          .padding(.bottom, 12)
          .font(PBFonts.title._1.font)
        Group {
          VStack(spacing: 24) {
            Group {
              Button {
                
              } label: {
                HStack {
                  PBImages.like.image
                  Text("친구에게 포비 추천하기")
                    .font(PBFonts.body._2.font)
                    .foregroundStyle(PBColors.navy._900.color)
                  Spacer()
                  PBImages.right.image
                }
              }
              Button {
                
              } label: {
                HStack {
                  PBImages.mail.image
                  Text("앱스토어 리뷰 쓰기")
                    .font(PBFonts.body._2.font)
                    .foregroundStyle(PBColors.navy._900.color)
                  Spacer()
                  PBImages.right.image
                }
              }
              Button {
                
              } label: {
                HStack {
                  Group {
                    PBImages.trash.image
                    Text("모든 리스트 초기화")
                      .font(PBFonts.body._2.font)
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
              Text("포비에게 궁금한 게 있다면\n언제든 연락주세요!")
                .lineSpacing(7)
                .font(PBFonts.body._4.font)
                .padding(.horizontal, 20)
              Button {
                
              } label: {
                Capsule()
                  .frame(width: 133, height: 40)
                  .foregroundStyle(PBColors.yellow._50.color)
                  .padding(.horizontal, 16)
                  .overlay {
                    Text("포비에게 카톡하기")
                      .font(PBFonts.body._4.font)
                      .foregroundStyle(PBColors.yellow._700.color)
                  }
              }
              .buttonStyle(.plain)
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
  MyPageView()
}
