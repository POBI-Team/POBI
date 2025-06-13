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

struct PocketMoreView<P: PocketModelable>: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  @Binding private var isPresentedEdit: Bool
  @State private var isPresentedDeleteAlert: Bool = false
  private let pocket: P
  
  init(_ pokcet: P, isPresentedEdit: Binding<Bool>) {
    self.pocket = pokcet
    self._isPresentedEdit = isPresentedEdit
  }
  
  var body: some View {
    PBColors.navy._10.color
      .ignoresSafeArea(.all)
      .overlay {
        VStack(spacing: 0) {
          VStack(spacing: 1) {
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
            if let pocket = pocket as? PocketModel {
              pocket.deletePushAlarm()
            }
            modelContext.delete(pocket)
            try? modelContext.save()
          }
        }
      }
      .presentationCornerRadius(30)
      .presentationDetents([.height(331)])
  }
}

#Preview {
  Color.white
    .sheet(
      isPresented: .constant(true),
      content: {
        PocketMoreView(PocketModel(id: .init(), title: "테스트"), isPresentedEdit: .constant(false))
      })
}
