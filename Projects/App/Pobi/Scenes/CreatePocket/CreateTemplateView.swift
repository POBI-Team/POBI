//
//  CreateTemplateView.swift
//  Pobi
//
//  Created by 이시원 on 6/11/25.
//

import SwiftUI
import SwiftData

import PBDesignSystem
import PBStorageInterface

struct CreateTemplateView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.modelContext) var modelContext
  @State private var template: Template
  @State private var isDidTapDownButton: Bool = true
  @State private var isPresentedEditAlert = false
  @State private var toastID: UUID?
  @FocusState private var isFocused: Bool
  
  private let templateModel: TemplateModel?
  
  init(template: TemplateModel?) {
    self.template = template?.temporary() ?? .init()
    self.templateModel = template
  }
  
  var body: some View {
    PBNavigationBar {
      PBColors.navy._10.color
        .ignoresSafeArea(.all)
        .pbAlert(isPresented: $isPresentedEditAlert, type: .edit) {
          templateModel?.paste(template)
          dismiss()
        }
        .overlay {
          VStack {
            InputTitleAndIconView(
              isFocused: $isFocused,
              isDidTapDownButton: $isDidTapDownButton,
              pocket: $template
            )
            Spacer()
          }
          .padding(.top, 24)
          .padding(.horizontal, 20)
        }
      PBRoundButton(16) {
        guard !template.title.isEmpty else { toastID = .init(); return }
        if templateModel == nil {
          let newTemplateModel = TemplateModel(template)
          modelContext.insert(newTemplateModel)
          dismiss()
        } else {
          isPresentedEditAlert.toggle()
        }
      } label: {
        Text("완료")
          .foregroundStyle(.white)
          .font(PBFonts.button._1.font)
      }
      .foregroundStyle(PBColors.navy._900.color)
      .frame(height: 52)
      .padding([.horizontal, .bottom], 14)
    }
    .leftItem {
      Button {
        dismiss()
      } label: {
        if templateModel != nil {
          PBImages.left.image
        } else {
          PBImages.cancel.image
        }
      }
    }
    .pbToast(toastID: $toastID, message: "포켓 이름을 입력해주세요!", height: 12)
  }
}

#Preview {
    CreateTemplateView(template: nil)
}
