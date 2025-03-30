//
//  RecommendedListView.swift
//  Pobi
//
//  Created by 이시원 on 3/30/25.
//

import SwiftUI

import PBDesignSystem
import NetworkService

struct RecommendedListView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var seletedCategoryIndex: Int = 0
  @State private var recommendedItem: PBRecommendedItem? = nil
  @State private var items: [String] = []
  @State private var seletedItems: [String] = []
  
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
                Spacer()
                PBImages.plus16.image
                  .rotationEffect(.init(degrees: iconAngle(items[i])))
              }
              .padding(.horizontal, 20)
              .padding(.vertical, 13)
              .background(cellBackgroundColor(items[i]))
              .clipShape(RoundedRectangle(cornerRadius: 12))
              .onTapGesture {
                withAnimation {
                  if seletedItems.contains(items[i]) {
                    seletedItems.removeAll { $0 == items[i] }
                  } else {
                    seletedItems.append(items[i])
                  }
                }
              }
            }
          }
        }
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
        
      } label: {
        PBImages.cancel.image
      }
    }
    .rightItem {
      Button {
        dismiss()
      } label: {
        Text("추가")
      }
      .foregroundStyle(PBColors.yellow._600.color)
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
    seletedItems.contains(item) ? PBColors.yellow._200.color : PBColors.navy._10.color
  }
  
  func iconAngle(_ item: String) -> Double {
    seletedItems.contains(item) ? 45.0 : 0
  }
}

#Preview {
  RecommendedListView()
}
