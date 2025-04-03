//
//  PocketMoreView.swift
//  Pobi
//
//  Created by 이시원 on 3/30/25.
//

import SwiftUI

import PBDesignSystem
import PBStorageInterface
import LocalNotiService

struct PocketMoreView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  @Binding var isPresentedCreate: Bool
  private let pocket: PocketModel
  
  init(_ pokcet: PocketModel, isPresentedCreate: Binding<Bool>) {
    self.pocket = pokcet
    self._isPresentedCreate = isPresentedCreate
  }
  
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
              isPresentedCreate = true
              dismiss()
            } label: {
              HStack(spacing: 8) {
                PBImages.edit.image
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
              dismiss()
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                let newPocket = pocket.copy()
                modelContext.insert(newPocket)
              }
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
              dismiss()
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                pocket.isHidden.toggle()
              }
            } label: {
              HStack(spacing: 8) {
                if pocket.isHidden {
                  PBImages.eyeOn.image
                } else {
                  PBImages.eyeOff.image
                }
                Text(pocket.isHidden ? "포켓 숨기기 해제" : "포켓 숨기기")
                  .foregroundStyle(PBColors.navy._900.color)
                  .font(PBFonts.button._1.font)
                Spacer()
              }
              .padding(.horizontal, 20)
              .padding(.vertical, 14)
            }
            .background(.white)
            
            Button {
              dismiss()
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                pocket.deletePushAlarm()
                modelContext.delete(pocket)
              }
            } label: {
              HStack(spacing: 8) {
                Group {
                  PBImages.trash.image
                  Text("삭제하기")
                    .font(PBFonts.button._1.font)
                }
                .foregroundStyle(PBColors.red.color)
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
            dismiss()
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
        PocketMoreView(.init(id: .init(), title: "테스트"), isPresentedCreate: .constant(false))
      })
}
