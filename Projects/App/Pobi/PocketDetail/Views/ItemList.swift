//
//  ItemList.swift
//  Pobi
//
//  Created by 이시원 on 2/21/25.
//

import SwiftUI

import PBDesignSystem
import PBStorageInterface

struct ItemList: View {
  private let pocket: PocketModel
  @Environment(\.modelContext) private var modelContext
  @State private var newPocketItem: PocketItemModel
  
  init(pocket: PocketModel) {
    self.pocket = pocket
    self.newPocketItem = .init()
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 21) {
      Text("\(pocket.items.count) items")
        .font(PBFonts.body._1.font)
        .foregroundStyle(PBColors.navy._100.color)
        .padding(.leading, 8)
      LazyVStack(alignment: .leading, spacing: 24) {
        ForEach(pocket.items.sorted(by: { $0.sortIndex < $1.sortIndex })) { item in
          PBCheckBoxTextField(
            title: Binding(get: { item.title }, set: { item.title = $0 }),
            memo: Binding(get: { item.memo }, set: { item.memo = $0 }),
            isChecked: Binding(get: { item.isChecked }, set: { item.isChecked = $0 })
          ) { onEidting in
            if !onEidting, item.title.isEmpty {
              withAnimation {
                pocket.deleteItem(withId: item.id)
              }
            }
          }
        }
        PBCheckBoxTextField(
          title: Binding(get: { newPocketItem.title }, set: { newPocketItem.title = $0 }),
          memo: Binding(get: { newPocketItem.memo }, set: { newPocketItem.memo = $0 }),
          isChecked: .constant(false)
        ) { isEidting in
          if !isEidting {
            if !newPocketItem.title.isEmpty {
              withAnimation {
                pocket.appendItem(newPocketItem)
              }
            }
          }
        }
      }
    }
    .onChange(of: pocket.items) { oldValue, newValue in
      print(newValue.map { $0.sortIndex })
      newPocketItem = PocketItemModel()
    }
  }
}

#Preview {
  ItemList(pocket: .init())
}
