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
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  private let pocket: PocketModel
  private let colors = PBColors.list.colors
  @State private var isPresnetedRecommend: Bool = false
  
  init(_ pocket: PocketModel) {
    self.pocket = pocket
  }
  
  var body: some View {
    PBNavigationBar {
      VStack(alignment: .leading, spacing: 25) {
        HStack {
          VStack(alignment: .leading) {
            Text(pocket.title)
              .font(PBFonts.title._1.font)
              .foregroundStyle(PBColors.navy._900.color)
            HStack(spacing: 8) {
              PBImages.clock.image
              Text(alarmLabel)
                .font(PBFonts.label._1.font)
                .foregroundStyle(PBColors.navy._400.color)
                .lineLimit(1)
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
      .onDisappear {
        try? modelContext.save()
      }
      .padding(.vertical, 20)
      .padding(.horizontal, 20)
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
    
    .leftItem {
      Button(action: {
        dismiss()
      }) {
        PBImages.left.image
      }
    }
    .rightItem {
      NavigationLink {
        CreatePocketView(.edit, pocket: pocket)
      } label: {
        PBImages.edit.image
      }
    }
  }
}

private extension PocketDetailView {
  var alarmLabel: String {
    if pocket.onAlarm {
      let time = PBFormatter.shared.label(pocket.alarm.time, format: "a h:mm", locale: Locale(identifier: "ko_KR"))
      if pocket.repeats {
        let days = PBFormatter.shared.label(isWeekDay: pocket.alarm.isWeekRepeat, days: pocket.alarm.days)
        return "\(days) / \(time)"
      }
      let date = PBFormatter.shared.label(pocket.alarm.date, format: "M월 d일")
      return "\(date) / \(time)"
    }
    return "알람 없음"
  }
}

#Preview {
  NavigationStack {
    PocketDetailView(
      PocketModel(
        title: "테스트",
        onAlarm: true,
        alarm: PocketAlarmModel(isWeekRepeat: true, days: [1,2], date: .now, time: .now)
      )
    )
  }
}
