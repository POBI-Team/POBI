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
  @FocusState private var focusIndex: Int?
  
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
    ScrollViewReader { proxy in
      List {
        Section {
          ForEach(lists.indices, id:\.self) { i in
            HStack {
              TextField(
                "",
                text: Binding(get: { lists[i].title }, set: { lists[i].title = $0 }),
                axis: .vertical
              )
              .focused($focusIndex, equals: i)
              .checkBoxAndMemoField(
                title: Binding(get: { lists[i].title }, set: { lists[i].title = $0 }),
                memo: Binding(get: { lists[i].memo }, set: { lists[i].memo = $0 }),
                isChecked: Binding(get: { lists[i].isChecked }, set: { lists[i].isChecked = $0 })
              ) {
                if lists[i].title.isEmpty {
                  lists.removeAll(where: { $0.id == lists[i].id })
                } else {
                  if focusIndex == lists.count - 1 {
                    focusIndex = -1
                  } else {
                    focusIndex! += 1
                  }
                }
              }
              .onChange(of: focusIndex) { _, newValue in
                if newValue != i, lists[i].title.isEmpty {
                  lists.removeAll(where: { $0.id == lists[i].id })
                }
              }
              .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                  lists.removeAll(where: { $0.id == lists[i].id })
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
          TextField("소지품", text: $newPocketItem.title, axis: .vertical)
            .onChange(of: focusIndex) { _, newValue in
              if newValue != -1, !newPocketItem.title.isEmpty {
                addItem()
              }
            }
            .checkBoxAndMemoField(title: $newPocketItem.title, memo: $newPocketItem.memo, isChecked: .constant(false)) {
              if !newPocketItem.title.isEmpty {
                addItem()
                withAnimation {
                  proxy.scrollTo(-1, anchor: .bottom)
                }
              } else {
                focusIndex = nil
              }
            }
            .focused($focusIndex, equals: -1)
            .padding(.horizontal, 4)
            .id(-1)
        }
        .listRowSeparator(.hidden)
      }
      .animation(.default, value: lists)
      .listStyle(PlainListStyle())
      .onChange(of: lists) { old, new in
        if old.count >= new.count {
          lists.updateSortIndices()
        }
        pocket.items = lists
      }
    }
  }
}

private extension ItemList {
  func addItem() {
    lists.append(newPocketItem)
    newPocketItem = PocketItemModel(sortIndex: lists.count)
  }
}

#Preview {
  ItemList(pocket: .init())
}
