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
  @EnvironmentObject var notificationManager: NotificationManager
  @Query(sort: [SortDescriptor<PocketModel>(\.createAt, order: .forward)])
  private var pockets: [PocketModel]
  @State private var isPresentedCreate: Bool = false
  @State private var isPresentedDetail: Bool = false
  @State private var seletedPocket: PocketModel?
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
      HStack {
        Spacer()
        PBPlusButton {
          isPresentedCreate.toggle()
        }
        .padding(.bottom, 10)
      }
    }
    .overlay {
      if pockets.filter({ pockectFilter($0) }).isEmpty {
        if seletedTabIndex == 0 {
          PocketListEmptyView()
            .padding(.bottom, 70)
        } else {
          PocketHiddenListEmptyView()
            .padding(.bottom, 70)
        }
      }
    }
    .fullScreenCover(isPresented: $isPresentedCreate) {
      NavigationStack {
        CreatePocketView(pocket: nil)
      }
    }
    .onAppear {
      if let id = notificationManager.seletedPocketID {
        seletedPocket = pockets.filter({$0.id == id}).first
      }
    }
    .navigationDestination(item: $seletedPocket) { pocket in
      PocketDetailView(pocket)
        .onAppear {
          notificationManager.seletedPocketID = nil
        }
    }
  }
}

#Preview {
  PocketList(seletedTabIndex: 0)
    .environmentObject(NotificationManager())
}
