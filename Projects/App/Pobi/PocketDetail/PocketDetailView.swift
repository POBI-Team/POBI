//
//  PocketDetailView.swift
//  Pobi
//
//  Created by 이시원 on 2/21/25.
//

import SwiftUI

import PBDesignSystem
import PBStorageInterface

struct PocketDetailView: View {
  @Environment(\.dismiss) private var dismiss
  private let pocket: PocketModel
  private let colors = PBColors.list.colors
  @State private var isPresnetedRecommend: Bool = false
  
  init(_ pocket: PocketModel) {
    self.pocket = pocket
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 25) {
      HStack {
        VStack(alignment: .leading) {
          Text(pocket.title)
            .font(PBFonts.title._1.font)
            .foregroundStyle(PBColors.navy._900.color)
          HStack(spacing: 2) {
            if let alarmDate = pocket.alarm?.date,
               let alarmTime = timeLabel {
              PBImages.clock.image
              Text("\(alarmDate) / \(alarmTime)")
                .font(PBFonts.label._1.font)
                .foregroundStyle(PBColors.navy._400.color)
                .lineLimit(1)
            }
          }
        }
        Spacer()
        PBCircleEmojiView(pocket.icon, size: .large)
          .frame(width: 60, height: 60)
          .foregroundStyle(colors[pocket.colorIndex]._01.color)
      }
      .padding(.vertical, 20)
      .padding(.horizontal, 24)
      .background(colors[pocket.colorIndex]._03.color)
      .clipShape(RoundedRectangle(cornerRadius: 20))
      
    }
    .padding(.top, 16)
    .padding(.horizontal, 20)
    .navigationBarBackButtonHidden()
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button(action: {
          dismiss()
        }) {
          PBImages.left.image
        }
      }
      ToolbarItem(placement: .topBarTrailing) {
        Button(action: {
          
        }) {
          PBImages.settingFill.image
        }
      }
    }
    .fullScreenCover(isPresented: $isPresnetedRecommend) {
      RecommendedListView(pocket: pocket)
    }
    
    ItemList(pocket: pocket)
      .scrollDismissesKeyboard(.interactively)
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
          .padding(.horizontal, 20)
          .background(PBColors.navy._900.color)
          .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .padding(.trailing, 16)
        .padding(.bottom, 20)
      }
  }
}

private extension PocketDetailView {
  var timeLabel: String? {
    guard let alarmTime = pocket.alarm?.time else { return nil }
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR") // 한국 로케일 설정
    formatter.dateFormat = "a h:mm" // "오전/오후 시:분" 형태
    return formatter.string(from: alarmTime)
  }
}

#Preview {
  NavigationStack {
    PocketDetailView(
      PocketModel(
        title: "테스트",
        alarm: PocketAlarmModel(date: "매주 월, 목", time: .now)
      )
    )
  }
}
