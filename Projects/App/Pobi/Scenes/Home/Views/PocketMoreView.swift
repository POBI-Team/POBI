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

struct PocketMoreView<P: CDPocketModelable>: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.managedObjectContext) private var context
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
              isPresentedEdit = true
              dismiss()
            } label: {
              HStack(spacing: 8) {
                Group {
                  PBImages.setting.image
                  Text("설정하기")
                    .font(PBFonts.button._3.font)
                }
                .foregroundStyle(PBColors.navy._900.color)
                Spacer()
              }
              .padding(.horizontal, 20)
              .padding(.vertical, 14)
            }
            .background(.white)
            
            if let pocket = pocket as? CDPocketModel {
              Button {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                  _ = pocket.copyModel()
                  try? context.save()
                }
              } label: {
                HStack(spacing: 8) {
                  Group {
                    PBImages.copy.image
                    Text("복제하기")
                      .font(PBFonts.button._3.font)
                  }
                  .foregroundStyle(PBColors.navy._900.color)
                  Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
              }
              .background(.white)
              
              Button {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                  _ = pocket.template()
                  FirebaseManager.shared.logEvent(event: .createTemplate)
                  try? context.save()
                }
              } label: {
                HStack(spacing: 8) {
                  Group {
                    PBImages.template.image
                    Text("템플릿으로 만들기")
                      .font(PBFonts.button._3.font)
                  }
                  .foregroundStyle(PBColors.navy._900.color)
                  Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
              }
              .background(.white)
            }
            
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
        .pbAlert(
          isPresented: $isPresentedDeleteAlert,
          type: pocket is CDPocketModel ? .delete : .deleteTemplate
        ) {
          dismiss()
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let pocket = pocket as? CDPocketModel {
              pocket.deletePushAlarm()
            }
            context.delete(pocket)
            try? context.save()
          }
        }
      }
      .presentationCornerRadius(30)
      .presentationDetents([.height(pocket is CDPocketModel ? 311 : 227)])
  }
}

//#Preview {
//  Color.white
//    .sheet(
//      isPresented: .constant(true),
//      content: {
//        PocketMoreView(PocketModel(id: .init(), title: "테스트"), isPresentedEdit: .constant(false))
//      })
//}
//
//#Preview("Template") {
//  Color.white
//    .sheet(
//      isPresented: .constant(true),
//      content: {
//        PocketMoreView(TemplateModel(id: .init(), title: "테스트"), isPresentedEdit: .constant(false))
//      })
//}
