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

import ComposableArchitecture

struct PocketList: View {
  @EnvironmentObject var notificationManager: NotificationManager
  
  @FetchRequest(sortDescriptors: [SortDescriptor(\.createAt, order: .reverse)])
  var pockets: FetchedResults<CDPocketModel>
  @FetchRequest(sortDescriptors: [SortDescriptor(\.createAt, order: .reverse)])
  var templates: FetchedResults<CDTemplateModel>
  
  @State private var isPresentedCreate: Bool = false
  @State private var isPresentedDetail: Bool = false
  @State private var seletedPocket: CDPocketModel?
  private let selectedTabIndex: Int
  
  init(selectedTabIndex: Int) {
    self.selectedTabIndex = selectedTabIndex
  }
  
  var body: some View {
    ScrollView {
      LazyVGrid(
        columns: [GridItem(.flexible(), spacing: 15), GridItem(.flexible())],
        spacing: 15
      ) {
        if selectedTabIndex == 0 {
          ForEach(pockets, id: \.id) { pocket in
            NavigationLink {
              PocketDetailView(pocket)
            } label: {
              PocketCell(pocket)
            }
          }
        } else {
          ForEach(templates, id: \.id) { template in
            NavigationLink {
              PocketDetailView(template)
            } label: {
              PocketCell(template)
            }
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
        .padding(.bottom, 24)
      }
    }
    .overlay {
      if selectedTabIndex == 0, pockets.isEmpty {
        PocketListEmptyView()
          .padding(.bottom, 70)
      } else if selectedTabIndex == 1, templates.isEmpty {
        TemplateListEmptyView()
          .padding(.bottom, 70)
      }
    }
    .fullScreenCover(isPresented: $isPresentedCreate) {
      NavigationStack {
        if selectedTabIndex == 0 {
          CreatePocketView(
            store: Store(initialState: CreatePocketFeature.State(pocket: nil)) {
              CreatePocketFeature()
            }
          )
        } else {
          CreateTemplateView(template: nil)
        }
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
  PocketList(selectedTabIndex: 0)
    .environmentObject(NotificationManager())
}
