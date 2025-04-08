//
//  PocketMoreView.swift
//  Pobi
//
//  Created by 이시원 on 3/30/25.
//

import SwiftUI

import PBDesignSystem
import PBStorage
import PBStorageInterface
import LocalNotiService

struct PocketMoreView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  @Binding private var isPresentedCreate: Bool
  @State private var isPresentedDeleteAlert: Bool = false
  @State private var isPresentedHiddenAlert: Bool = false
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
          VStack(spacing: 1) {
            if !pocket.isHidden {
              Button {
                isPresentedCreate = true
                dismiss()
              } label: {
                HStack(spacing: 8) {
                  PBImages.setting.image
                  Text("설정하기")
                    .foregroundStyle(PBColors.navy._900.color)
                    .font(PBFonts.button._3.font)
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
                  try? modelContext.save()
                }
              } label: {
                HStack(spacing: 8) {
                  PBImages.copy.image
                  Text("복제하기")
                    .foregroundStyle(PBColors.navy._900.color)
                    .font(PBFonts.button._3.font)
                  Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
              }
              .background(.white)
            }
            
            Button {
              if !pocket.isHidden {
                isPresentedHiddenAlert.toggle()
              } else {
                pocket.registerPushAlarm(userNickname: ProfileStorage.shared.loadNickname() ?? "사용자")
                dismiss()
                FirebaseManager.shared.logEvent(event: .didTapPocketShown)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                  pocket.isHidden.toggle()
                  try? modelContext.save()
                }
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
                  .font(PBFonts.button._3.font)
                Spacer()
              }
              .padding(.horizontal, 20)
              .padding(.vertical, 14)
            }
            .background(.white)
            
            Button {
              isPresentedDeleteAlert.toggle()
            } label: {
              HStack(spacing: 8) {
                Group {
                  PBImages.trash.image
                  Text("삭제하기")
                    .font(PBFonts.button._3.font)
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
          .padding(.top, 24)
          
          PBRoundButton(16) {
            dismiss()
          } label: {
            Text("닫기")
              .foregroundStyle(PBColors.navy._900.color)
              .font(PBFonts.button._3.font)
          }
          .frame(height: 52)
          .foregroundStyle(.white)
          .padding(.top, 19)
          Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .pbAlert(isPresented: $isPresentedDeleteAlert, type: .delete) {
          dismiss()
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            pocket.deletePushAlarm()
            modelContext.delete(pocket)
            try? modelContext.save()
          }
        }
        .pbAlert(isPresented: $isPresentedHiddenAlert, type: .hidden) {
          pocket.deletePushAlarm()
          dismiss()
          FirebaseManager.shared.logEvent(event: .didTapPocketHidden)
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            pocket.isHidden.toggle()
            try? modelContext.save()
          }
        }
      }
      .presentationCornerRadius(30)
      .presentationDetents([.height(pocket.isHidden ? 227 : 331)])
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

#Preview("숨김") {
  Color.white
    .sheet(
      isPresented: .constant(true),
      content: {
        PocketMoreView(.init(id: .init(), title: "테스트", isHidden: true), isPresentedCreate: .constant(false))
      })
}
