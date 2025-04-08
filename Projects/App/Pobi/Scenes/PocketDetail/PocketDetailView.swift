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
            HStack(spacing: 6) {
              if pocket.isHidden {
                PBImages.eyeOff.image
                  .renderingMode(.template)
                  .resizable()
                  .frame(width: 16, height: 16)
                  .foregroundStyle(PBColors.navy._400.color)
              } else {
                PBImages.clock.image
              }
              alarmLabel
                .font(PBFonts.label._1.font)
                .foregroundStyle(PBColors.navy._400.color)
                .lineLimit(1)
            }
          }
          Spacer()
          PBCircleEmojiView(pocket.icon, size: .large)
            .frame(width: 60, height: 60)
            .foregroundStyle(.white)
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
        .padding(.leading, 2)
        .scrollDismissesKeyboard(.interactively)
        .overlay(alignment: .bottomTrailing) {
          if !pocket.isHidden {
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
        PBImages.setting.image
          .renderingMode(.template)
      }
      .tint(PBColors.navy._900.color)
      .disabled(pocket.isHidden)
    }
  }
}

private extension PocketDetailView {
  var alarmLabel: some View {
    if pocket.isHidden { return AnyView(Text("숨긴 포켓")) }
    if pocket.onAlarm {
      let time = PBFormatter.shared.label(pocket.alarm.time, format: "a h:mm", locale: Locale(identifier: "ko_KR"))
      if pocket.repeats {
        let days = PBFormatter.shared.label(isWeekDay: pocket.alarm.isWeekRepeat, days: pocket.alarm.days)
        return AnyView(
          HStack(spacing: 0) {
            Text("\(days)")
              .frame(maxWidth: 112, alignment: .leading)
              .fixedSize(horizontal: true, vertical: false)
            Text(" / ")
            Text("\(time)")
          })
      }
      let date = PBFormatter.shared.label(pocket.alarm.date, format: "M월 d일")
      return AnyView(
        HStack(spacing: 0) {
          Text("\(date)")
          Text(" / ")
          Text("\(time)")
        })
    }
    return AnyView(Text("알람 없음"))
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

#Preview {
  NavigationStack {
    PocketDetailView(
      PocketModel(
        title: "테스트",
        onAlarm: true,
        repeats: true,
        isHidden: true,
        alarm: PocketAlarmModel(isWeekRepeat: true, days: [1,2,3,4,5,6], date: .now, time: .now)
      )
    )
  }
}
