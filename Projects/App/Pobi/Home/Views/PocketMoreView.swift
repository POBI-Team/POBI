//
//  PocketMoreView.swift
//  Pobi
//
//  Created by 이시원 on 3/30/25.
//

import SwiftUI

import PBDesignSystem

struct PocketMoreView: View {
  var body: some View {
    PBColors.navy._10.color
      .ignoresSafeArea(.all)
      .overlay {
        VStack(spacing: 0) {
          Capsule()
            .foregroundStyle(PBColors.navy._50.color)
            .frame(width: 36, height: 5)
          VStack(spacing: 1) {
            Button {
              
            } label: {
              HStack(spacing: 8) {
                PBImages.setting.image
                Text("수정하기")
                  .foregroundStyle(PBColors.navy._900.color)
                  .font(PBFonts.button._1.font)
                Spacer()
              }
              .padding(.horizontal, 20)
              .padding(.vertical, 14)
            }
            .background(.white)
           
            Button {
              
            } label: {
              HStack(spacing: 8) {
                PBImages.copy.image
                Text("복제하기")
                  .foregroundStyle(PBColors.navy._900.color)
                  .font(PBFonts.button._1.font)
                Spacer()
              }
              .padding(.horizontal, 20)
              .padding(.vertical, 14)
            }
            .background(.white)
            
            Button {
              
            } label: {
              HStack(spacing: 8) {
                PBImages.eyeOff.image
                Text("포켓 숨기기")
                  .foregroundStyle(PBColors.navy._900.color)
                  .font(PBFonts.button._1.font)
                Spacer()
              }
              .padding(.horizontal, 20)
              .padding(.vertical, 14)
            }
            .background(.white)
            
            Button {
              
            } label: {
              HStack(spacing: 8) {
                PBImages.trash.image
                Text("삭제하기")
                  .foregroundStyle(PBColors.red.color)
                  .font(PBFonts.button._1.font)
                Spacer()
              }
              .padding(.horizontal, 20)
              .padding(.vertical, 14)
            }
            .background(.white)
          }
          .clipShape(RoundedRectangle(cornerRadius: 16))
          .padding(.top, 27)
          
          PBRoundButton(16) {
            
          } label: {
            Text("닫기")
              .foregroundStyle(PBColors.navy._900.color)
              .font(PBFonts.button._1.font)
          }
          .frame(height: 52)
          .foregroundStyle(.white)
          .padding(.top, 19)
          Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
      }
      .presentationDetents([.height(331)])
  }
}

#Preview {
  Color.white
    .sheet(
      isPresented: .constant(true),
      content: {
        PocketMoreView()
      })
}
