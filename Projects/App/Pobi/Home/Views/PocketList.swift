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
  
  var body: some View {
    ScrollView {
      LazyVGrid(
        columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible())],
        spacing: 15
      ) {
        ForEach(pockets) { pocket in
          PocketCell(
            title: pocket.title,
            listColor: PBColors.list.blue.self
          )
        }
      }
      .padding(.bottom, 80)
    }
    .scrollIndicators(.hidden)
    .overlay(alignment: .bottom) {
      PBPlusButton {
        isPresentedCreate.toggle()
      }
    }
    .fullScreenCover(isPresented: $isPresentedCreate) {
      NavigationStack {
        CreatePocketView()
      }
    }
  }
}

#Preview {
  PocketList()
}
