//
//  ItemList.swift
//  Pobi
//
//  Created by 이시원 on 2/21/25.
//

import Foundation
import SwiftUI
import CoreData

import PBDesignSystem
import PBStorageInterface

struct ItemList<P: CDPocketModelable>: View {
  private let pocket: P
  @Environment(\.managedObjectContext) private var managedObjectContext
  @State private var newPocketItem: CDPocketItemModel
  @State private var itemList: [CDPocketItemModel]
  @State private var isPresnetedRecommend: Bool = false
  @FocusState private var focusIndex: Int?
  
  init(pocket: P, managedObjectContext: NSManagedObjectContext) {
    self.pocket = pocket
    self.itemList = pocket.items.sorted(by: { $0.sortIndex < $1.sortIndex })
    self.newPocketItem = CDPocketItemModel(context: managedObjectContext)
    newPocketItem.sortIndex = Int64(pocket.items.count)
  }
  
  var body: some View {
    HStack {
      Text("소지품 \(itemList.count)개")
        .font(PBFonts.caption._2.font)
        .foregroundStyle(PBColors.navy._100.color)
      Spacer()
      if pocket is CDPocketModel {
        Button {
          for i in itemList.indices {
            itemList[i].isChecked = false
          }
          FirebaseManager.shared.logEvent(event: .didTapReset)
        } label: {
          HStack(alignment: .center, spacing: 6) {
            Text("체크 리셋")
              .font(PBFonts.label._1.font)
            PBImages.reset.image
              .renderingMode(.template)
          }
          .frame(height: 16)
        }
        .tint(PBColors.red.color)
      }
    }
    .padding(.horizontal, 28)
    .padding(.bottom, 8)
    ScrollViewReader { proxy in
      List {
        Section {
          ForEach(Array(itemList.enumerated()), id: \.element) { i, item in
            HStack {
              TextField(
                "소지품",
                text: Binding(get: { item.title }, set: { item.title = $0 }),
                axis: .vertical
              )
              .focused($focusIndex, equals: i)
              .checkBoxAndMemoField(
                title: Binding(get: { item.title }, set: { item.title = $0 }),
                memo: Binding(get: { item.memo }, set: { item.memo = $0 }),
                isChecked: Binding(get: { item.isChecked }, set: { item.isChecked = $0 }),
                isDisable: pocket is CDTemplateModel
              ) {
                if item.title.isEmpty {
                  itemList.removeAll(where: { $0.id == item.id })
                } else {
                  if focusIndex == itemList.count - 1 {
                    focusIndex = -1
                  } else {
                    focusIndex! += 1
                  }
                }
              }
              .onChange(of: focusIndex) { _, newValue in
                if newValue != i, item.title.isEmpty {
                  itemList.removeAll(where: { $0.id == item.id })
                }
              }
              .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                  itemList.removeAll(where: { $0.id == item.id })
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
            itemList.move(fromOffsets: indexSet, toOffset: index)
          }
          TextField("소지품", text: $newPocketItem.title, axis: .vertical)
            .onChange(of: focusIndex) { _, newValue in
              if newValue != -1, !newPocketItem.title.isEmpty {
                addItem()
              }
            }
            .checkBoxAndMemoField(
              title: $newPocketItem.title,
              memo: $newPocketItem.memo,
              isChecked: .constant(false)
            ) {
              if !newPocketItem.title.isEmpty {
                addItem()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                  withAnimation {
                    proxy.scrollTo(-1, anchor: .bottom)
                  }
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
      .animation(.default, value: itemList)
      .listStyle(PlainListStyle())
      .onChange(of: itemList) { old, new in
        if old.count >= new.count {
          itemList.updateSortIndices()
        }
        pocket.items = Set(itemList)
        try? managedObjectContext.save()
      }
    }
    .fullScreenCover(isPresented: $isPresnetedRecommend) {
      RecommendedListView(pocketItems: $itemList)
    }
    .overlay(alignment: .bottomTrailing) {
      Button {
        isPresnetedRecommend = true
      } label: {
        HStack(spacing: 4) {
          PBImages.lamp.image
          Text("추천")
            .font(PBFonts.button._1.font)
            .foregroundStyle(.white)
        }
        .padding(.vertical, 9)
        .padding(.leading, 16)
        .padding(.trailing, 20)
        .background(PBColors.navy._900.color)
        .clipShape(Capsule())
      }
      .buttonStyle(.plain)
      .padding(.trailing, 16)
      .padding(.bottom, 20)
    }
  }
}


private extension ItemList {
  func addItem() {
    itemList.append(newPocketItem)
    newPocketItem = CDPocketItemModel(context: managedObjectContext)
    newPocketItem.sortIndex = Int64(pocket.items.count)
  }
}

//#Preview {
//  ItemList(pocket: PocketModel())
//}
//
//#Preview("Template") {
//  ItemList(pocket: TemplateModel())
//}
