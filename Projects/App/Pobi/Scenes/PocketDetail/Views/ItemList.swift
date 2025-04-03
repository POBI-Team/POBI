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
    List {
      Section {
        Text("\(pocket.items.count) items")
          .font(PBFonts.body._1.font)
          .foregroundStyle(PBColors.navy._100.color)
          .padding(.leading, 8)
        ForEach(pocket.items.sorted(by: { $0.sortIndex < $1.sortIndex })) { item in
          HStack {
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
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
              Button(role: .destructive) {
                pocket.deleteItem(withId: item.id)
              } label: {
                Text("삭제")
                  .font(PBFonts.button._3.font)
              }
            }
            Spacer()
            PBImages.slide.image
          }
        }
 
        .onMove { indexSet, index in
          pocket.items.move(fromOffsets: indexSet, toOffset: index)
          pocket.updateSortIndices()
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
      .listRowSeparator(.hidden)
    }
    .listStyle(PlainListStyle())
    .onChange(of: pocket.items) { oldValue, newValue in
      newPocketItem = PocketItemModel()
    }
  }
}

#Preview {
  ItemList(pocket: .init())
}
