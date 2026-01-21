//
//  ItemView.swift
//  Pobi
//
//  Created by 이시원 on 12/29/25.
//

import SwiftUI

import PBStorageInterface
import PBDesignSystem

struct ItemView<T: CDPocketModelable>: View {
  @ObservedObject private var item: CDPocketItemModel
  private var onSubmit: () -> Void = {}
  
  init(
    item: CDPocketItemModel,
    onSubmit: @escaping () -> Void = {}
  ) {
    self.item = item
    self.onSubmit = onSubmit
  }
  
  var body: some View {
    HStack {
      TextField(
        "소지품",
        text: $item.title,
        axis: .vertical
      )
      .checkBoxAndMemoField(
        title: $item.title,
        memo: $item.memo,
        isChecked: $item.isChecked,
        isDisable: T.self == CDTemplateModel.self,
        onSubmitAction: onSubmit
      )
      .animation(.default, value: item.isChecked)
      Spacer()
      PBImages.slide.image
    }
    .padding(.horizontal, 4)
  }
}
