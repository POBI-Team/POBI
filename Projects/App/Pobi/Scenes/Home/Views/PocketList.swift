//
//  PocketList.swift
//  Pobi
//
//  Created by 이시원 on 2/15/25.
//

import SwiftUI
import SwiftData

import PBDesignSystem
import PBStorageInterface

struct PocketList: View {
  @Query(sort: [SortDescriptor<PocketModel>(\.createAt, order: .forward)])
  private var pockets: [PocketModel]
  @State private var isPresentedCreate: Bool = false
  private var seletedTabIndex: Int
  
  private func pockectFilter(_ pocket: PocketModel) -> Bool {
    switch seletedTabIndex {
    case 0:
      return !pocket.isHidden
    case 1:
      return pocket.isHidden
    default:
      return false
    }
  }
  
  init(seletedTabIndex: Int) {
    self.seletedTabIndex = seletedTabIndex
  }
  
  var body: some View {
    ScrollView {
      LazyVGrid(
        columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible())],
        spacing: 15
      ) {
        ForEach(pockets.filter { pockectFilter($0) }) { pocket in
          NavigationLink {
            PocketDetailView(pocket)
          } label: {
            PocketCell(pocket)
          }
        }
      }
      .padding(.bottom, 80)
    }
    .scrollIndicators(.hidden)
    .overlay(alignment: .bottom) {
      PBPlusButton {
        isPresentedCreate.toggle()
      }
      .padding(.bottom, 10)
    }
    .overlay {
      if pockets.filter({ pockectFilter($0) }).isEmpty {
        PocketListEmptyView()
          .padding(.bottom, 70)
      }
    }
    .fullScreenCover(isPresented: $isPresentedCreate) {
      NavigationStack {
        CreatePocketView(.create, pocket: .init())
      }
    }
  }
}

#Preview {
  PocketList(seletedTabIndex: 0)
}
