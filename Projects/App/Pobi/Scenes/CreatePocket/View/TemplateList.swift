//
//  TemplateList.swift
//  Pobi
//
//  Created by 이시원 on 6/19/25.
//

import SwiftUI
import SwiftData

import PBDesignSystem
import PBStorageInterface

struct TemplateList: View {
  @Environment(\.dismiss) private var dismiss
  @Binding private var selectedTemplate: TemplateModel?
  @State private var tempTemplate: TemplateModel?
  
  #if DEBUG
  private var templates: [TemplateModel] = [
    TemplateModel(title: "템플릿 1", icon: "✈️"),
    TemplateModel(title: "템플릿 2", icon: "✈️"),
    TemplateModel(title: "템플릿 3", icon: "✈️")
  ]
  #else
  @Query(sort: [SortDescriptor<TemplateModel>(\.createAt, order: .forward)])
  private var templates: [TemplateModel]
  #endif
  
  init(selectedTemplate: Binding<TemplateModel?>) {
    self._selectedTemplate = selectedTemplate
  }
  
  var body: some View {
    PBNavigationBar {
      ScrollView {
        LazyVStack(spacing: 12) {
          ForEach(templates) { template in
            HStack(spacing: 8) {
              Text(template.icon ?? "")
                .font(PBFonts.tossFace.xsmall.font)
              Text(template.title)
                .font(PBFonts.body._2.font)
                .foregroundStyle(PBColors.navy._900.color)
              Spacer()
              Text("소지품 \(template.items.count)개")
                .font(PBFonts.label._2.font)
                .foregroundStyle(PBColors.navy._300.color)
              Circle()
                .stroke(lineWidth: 2)
                .foregroundStyle(tempTemplate?.id == template.id ? PBColors.navy._900.color : PBColors.navy._100.color)
                .frame(width: 18, height: 18)
                .overlay {
                  if tempTemplate?.id == template.id {
                    Circle()
                      .frame(width: 14, height: 14)
                      .foregroundStyle(PBColors.navy._900.color)
                  }
                }
            }
            .animation(.default, value: tempTemplate)
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(PBColors.list.gray._03.color)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onTapGesture {
              if tempTemplate?.id != template.id {
                tempTemplate = template
              } else {
                tempTemplate = nil
              }
            }
          }
        }
        .padding(20)
      }
      .overlay {
        if templates.isEmpty {
          VStack(spacing: 8) {
            Text("템플릿이 없어요!")
              .font(PBFonts.title._1.font)
              .foregroundStyle(PBColors.navy._900.color)
            Text("자주 쓰고 싶은 포켓이 있다면,\n‘내 포켓’ 또는 ‘템플릿'에서 템플릿으로 만들 수 있어요")
              .font(PBFonts.body._4.font)
              .foregroundStyle(PBColors.navy._200.color)
              .multilineTextAlignment(.center)
              .lineSpacing(6)
          }
        }
      }
    }
    .title("템플릿 리스트")
    .leftItem {
      Button {
        dismiss()
      } label: {
        PBImages.cancel.image
      }
    }
    .rightItem {
      Button {
        selectedTemplate = tempTemplate
        dismiss()
      } label: {
        Text("추가")
          .font(PBFonts.button._1.font)
      }
      .tint(PBColors.yellow._600.color)
      .disabled(tempTemplate == nil)
    }
  }
}

#Preview {
  @Previewable @State var selectedTemplate: TemplateModel? = nil
  
  TemplateList(selectedTemplate: $selectedTemplate)
}
