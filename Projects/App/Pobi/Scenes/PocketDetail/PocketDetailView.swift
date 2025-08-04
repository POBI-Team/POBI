//
//  PocketDetailView.swift
//  Pobi
//
//  Created by 이시원 on 2/21/25.
//

import SwiftUI

import PBDesignSystem
import PBStorageInterface

import ComposableArchitecture

struct PocketDetailView<P: PocketModelable>: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var formatter: PBFormatter
  private let pocket: P
  private let colors = PBColors.list.colors
  
  init(_ pocket: P) {
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
            if let pocket = pocket as? PocketModel {
              HStack(spacing: 6) {
                PBImages.clock.image
                alarmLabel(pocket)
                  .font(PBFonts.label._1.font)
                  .foregroundStyle(PBColors.navy._400.color)
                  .lineLimit(1)
              }
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
      ItemList(pocket: pocket)
        .padding(.leading, 2)
        .scrollDismissesKeyboard(.interactively)
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
        if let pocket = pocket as? PocketModel {
          CreatePocketView(
            store: Store(initialState: CreatePocketFeature.State(pocket: pocket)) {
              CreatePocketFeature()
            }
          )
        } else if let template = pocket as? TemplateModel {
          CreateTemplateView(template: template)
        }
      } label: {
        PBImages.setting.image
          .renderingMode(.template)
      }
      .tint(PBColors.navy._900.color)
    }
  }
}

private extension PocketDetailView {
  func alarmLabel(_ pocket: PocketModel) -> some View {
    if pocket.onAlarm {
      let time = formatter.label(pocket.alarm.time, format: "a h:mm", locale: Locale(identifier: "ko_KR"))
      if pocket.repeats {
        let days = formatter.label(isWeekDay: pocket.alarm.isWeekRepeat, days: pocket.alarm.days)
        return AnyView(
          HStack(spacing: 0) {
            Text("\(days)")
              .frame(maxWidth: 112, alignment: .leading)
              .fixedSize(horizontal: true, vertical: false)
            Text(" / ")
            Text("\(time)")
          })
      }
      var date = formatter.alarmLabel(
        pocket.alarm.date,
        endDate: pocket.alarm.endDate
      )
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
        alarm: PocketAlarmModel(
          isWeekRepeat: true,
          days: [1,2],
          date: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 20))!,
          endDate:  Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 29))!,
          time: .now
        )
      )
    )
    .environmentObject(PBFormatter())
  }
}

#Preview {
  NavigationStack {
    PocketDetailView(
      PocketModel(
        title: "테스트",
        onAlarm: true,
        alarm: PocketAlarmModel(
          isWeekRepeat: true,
          days: [1,2],
          date: .now,
          endDate: .now,
          time: .now
        )
      )
    )
    .environmentObject(PBFormatter())
  }
}

#Preview {
  NavigationStack {
    PocketDetailView(
      PocketModel(
        title: "테스트",
        onAlarm: true,
        repeats: true,
        alarm: PocketAlarmModel(isWeekRepeat: true, days: [1,2,3,4,5,6], date: .now, time: .now)
      )
    )
    .environmentObject(PBFormatter())
  }
}
