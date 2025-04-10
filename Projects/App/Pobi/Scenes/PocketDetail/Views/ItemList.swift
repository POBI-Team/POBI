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
  @State private var lists: [PocketItemModel]
  
  init(pocket: PocketModel) {
    self.pocket = pocket
    self.lists = pocket.items.sorted(by: { $0.sortIndex < $1.sortIndex })
    self.newPocketItem = .init()
  }
  
  var body: some View {
    HStack {
      Text("\(lists.count) items")
        .font(PBFonts.body._1.font)
        .foregroundStyle(PBColors.navy._100.color)
      Spacer()
      Button {
        for i in lists.indices {
          lists[i].isChecked = false
        }
      } label: {
        HStack(alignment: .center, spacing: 6) {
          Text("reset")
            .font(PBFonts.caption._1.font)
          PBImages.reset.image
            .renderingMode(.template)
        }
        .frame(height: 16)
      }
      .tint(PBColors.red.color)
    }
    .padding(.horizontal, 28)
    .padding(.bottom, 8)
    List {
      Section {
        ForEach(lists) { item in
          HStack {
            PBCheckBoxTextField(
              title: Binding(get: { item.title }, set: { item.title = $0 }),
              memo: Binding(get: { item.memo }, set: { item.memo = $0 }),
              isChecked: Binding(get: { item.isChecked }, set: { item.isChecked = $0 })
            ) { onEidting in
              if !onEidting, item.title.isEmpty {
                withAnimation {
                  lists.removeAll(where: { $0.id == item.id })
                }
              }
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
              Button(role: .destructive) {
                lists.removeAll(where: { $0.id == item.id })
              } label: {
                Text("삭제")
                  .font(PBFonts.button._3.font)
              }
            }
            Spacer()
            PBImages.slide.image
          }
          .padding(.horizontal, 4)
        }
        .onMove { indexSet, index in
          lists.move(fromOffsets: indexSet, toOffset: index)
        }
        PBCheckBoxTextField(
          title: Binding(get: { newPocketItem.title }, set: { newPocketItem.title = $0 }),
          memo: Binding(get: { newPocketItem.memo }, set: { newPocketItem.memo = $0 }),
          isChecked: .constant(false)
        ) { isEidting in
          if !isEidting {
            if !newPocketItem.title.isEmpty {
              lists.append(newPocketItem)
              newPocketItem = PocketItemModel(sortIndex: lists.count)
            }
          }
        }
        .padding(.horizontal, 4)
      }
      .listRowSeparator(.hidden)
    }
    .animation(.default, value: lists)
    .listStyle(PlainListStyle())
    .onChange(of: lists) { old, new in
      if old.count >= new.count {
        for (index, item) in lists.enumerated() {
          item.sortIndex = index
        }
      }
      pocket.items = lists
    }
  }
}

#Preview {
  ItemList(pocket: .init())
}
