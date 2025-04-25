//
//  RecommendedListView.swift
//  Pobi
//
//  Created by 이시원 on 3/30/25.
//

import SwiftUI

import PBDesignSystem
import NetworkService
import PBStorageInterface

struct RecommendedListView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var seletedCategoryIndex: Int = 0
  @State private var recommendedItem: PBRecommendedItem? = nil
  @State private var items: [String] = []
  @State private var seletedItemTitles: Set<String>
  @State private var seletedItems: [PocketItem]
  @Binding private var pocketItems: [PocketItemModel]
  
  init(pocketItems: Binding<[PocketItemModel]>) {
    self._pocketItems = pocketItems
    self.seletedItems = pocketItems.wrappedValue.map { PocketItem(model: $0) }
    self.seletedItemTitles = Set(pocketItems.wrappedValue.map(\.title))
  }
  
  var body: some View {
    PBNavigationBar {
      VStack(spacing: 24) {
        ScrollView(.horizontal, showsIndicators: false) {
          PBSegmentView(
            selected: $seletedCategoryIndex,
            items: [
              .init("외출", icon: "👟"),
              .init("출근", icon: "💼"),
              .init("운동", icon: "💪"),
              .init("국내 여행", icon: "🚗"),
              .init("해외 여행", icon: "✈️"),
            ]
          )
          .unSelectedColor(.clear)
          .padding(.horizontal, 20)
        }
        ScrollView {
          LazyVStack(spacing: 12) {
            ForEach(items.indices, id: \.self) { i in
              HStack {
                Text(items[i])
                  .font(PBFonts.body._3.font)
                  .foregroundStyle(PBColors.navy._900.color)
                Spacer()
                PBImages.plus16.image
                  .renderingMode(.template)
                  .foregroundStyle(iconColor(items[i]))
                  .rotationEffect(.init(degrees: iconAngle(items[i])))
              }
              .frame(height: 48)
              .padding(.horizontal, 20)
              .background(cellBackgroundColor(items[i]))
              .clipShape(RoundedRectangle(cornerRadius: 12))
              .onTapGesture {
                withAnimation {
                  if seletedItemTitles.contains(items[i]) {
                    seletedItemTitles.remove(items[i])
                    seletedItems.removeAll { $0.title == items[i] }
                  } else {
                    seletedItemTitles.insert(items[i])
                    seletedItems.append(PocketItem(title: items[i]))
                  }
                }
              }
            }
          }
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 20)
        .overlay {
          if recommendedItem == nil {
            ProgressView()
          }
        }
      }
      .padding(.top, 20)
      
    }
    .title("소지품 추천 리스트")
    .leftItem {
      Button {
        dismiss()
      } label: {
        PBImages.cancel.image
      }
    }
    .rightItem {
      Button {
        dismiss()
        pocketItems = seletedItems.map { $0.toModel() }
        pocketItems.updateSortIndices()
        FirebaseManager.shared.logEvent(event: .addRecommendedList)
      } label: {
        Text("추가")
          .font(PBFonts.button._1.font)
      }
      .foregroundStyle(PBColors.yellow._600.color)
    }
    .onChange(of: seletedCategoryIndex) { oldValue, newValue in
      guard oldValue != newValue,
            let recommendedItem else { return }
      switch newValue {
      case 0:
        items = recommendedItem.outing
      case 1:
        items = recommendedItem.work
      case 2:
        items = recommendedItem.health
      case 3:
        items = recommendedItem.domesticTravel
      case 4:
        items = recommendedItem.overseasTravel
      default: break
      }
    }
    .onAppear {
      Task {
        do {
          recommendedItem = try await NetworkClient.shared.request(
            target: FirebaseAPI.items,
            of: PBRecommendedItem.self
          )
          items = recommendedItem?.work ?? []
        } catch {
          #warning("에러 처리")
        }
      }
    }
  }
}

private extension RecommendedListView {
  func cellBackgroundColor(_ item: String) -> Color {
    seletedItemTitles.contains(item) ? PBColors.yellow._200.color : PBColors.navy._10.color
  }
  
  func iconAngle(_ item: String) -> Double {
    seletedItemTitles.contains(item) ? 45.0 : 0
  }
  
  func iconColor(_ item: String) -> Color {
    seletedItemTitles.contains(item) ? PBColors.yellow._600.color : PBColors.navy._100.color
  }
}

#Preview {
  RecommendedListView(pocketItems: .constant([]))
}
