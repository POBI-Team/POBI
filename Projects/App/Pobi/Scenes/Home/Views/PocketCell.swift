//
//  PocketCell.swift
//  Pobi
//
//  Created by 이시원 on 2/19/25.
//

import SwiftUI

import PBDesignSystem
import PBStorageInterface

import ComposableArchitecture

struct PocketCell<P: CDPocketModelable>: View {
  private var pocket: P
  private let colors = PBColors.list.colors
  @State private var isPresentedPocketMore = false
  @State private var isPresentedEdit = false
  @EnvironmentObject private var formatter: PBFormatter
  
  init (_ pocket: P) {
    self.pocket = pocket
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Spacer()
        .frame(height: 16)
      VStack(alignment: .leading, spacing: 10) {
        PBCircleEmojiView(pocket.icon, size: .small)
          .foregroundStyle(.white)
        VStack(alignment: .leading, spacing: 6) {
          Text(pocket.title)
            .lineLimit(1)
            .font(PBFonts.title._2.font)
            .foregroundStyle(PBColors.navy._900.color)
          if let pocket = pocket as? CDPocketModel {
            Text(alarmLabel(pocket))
              .font(PBFonts.label._1.font)
              .lineLimit(1)
              .foregroundStyle(PBColors.navy._400.color)
          }
        }
      }
      .padding(.horizontal, 16)
      Spacer()
      HStack {
        Text("소지품 \(pocket.items.count)개")
          .font(PBFonts.caption._2.font)
          .foregroundStyle(PBColors.navy._900.color)
        Spacer()
        PBImages.right.image
      }
      .padding(.leading, 16)
      .padding(.trailing, 12)
      .frame(height: 40)
      .background(colors[Int(pocket.colorIndex)]._02.color)
      .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    .sheet(isPresented: $isPresentedPocketMore) {
      PocketMoreView(pocket, isPresentedEdit: $isPresentedEdit)
    }
    .background(colors[Int(pocket.colorIndex)]._03.color)
    .clipShape(RoundedRectangle(cornerRadius: 20))
    .aspectRatio(1, contentMode: .fit)
    .overlay(alignment: .top) {
      HStack {
        Spacer()
        Button {
          withAnimation {
            isPresentedPocketMore = true
          }
          
        } label: {
          PBImages.manu.image
        }
      }
      .padding(.top, 20)
      .padding(.trailing, 12)
    }
    .navigationDestination(isPresented: $isPresentedEdit) {
      if let pocket = pocket as? CDPocketModel {
        CreatePocketView(
          store: Store(initialState: CreatePocketFeature.State(pocket: pocket)) {
            CreatePocketFeature()
          }
        )
      } else if let template = pocket as? CDTemplateModel {
        CreateTemplateView(template: template)
      }
    }
  }
}

private extension PocketCell {
  func alarmLabel(_ pocket: CDPocketModel) -> String {
    if pocket.repeats {
      return formatter.label(isWeekDay: pocket.alarm.isWeekRepeat, days: pocket.alarm.days)
    }
    return formatter.alarmLabel(pocket.alarm.date, endDate: pocket.alarm.endDate)
  }
}

//#Preview("week") {
//  PocketCell(PocketModel(id: .init(), title: "테스트", onAlarm: true, repeats: true, alarm: .init(isWeekRepeat: true, days: [1,2,3,4,5,6], date: .now, time: .now)))
//    .environmentObject(PBFormatter())
//}
//
//#Preview("day") {
//  PocketCell(PocketModel(id: .init(), title: "테스트", onAlarm: true, repeats: true, alarm: .init(isWeekRepeat: false, days: [1,2], date: .now, time: .now)))
//    .environmentObject(PBFormatter())
//}
//
//#Preview("date") {
//  PocketCell(PocketModel(id: .init(), title: "테스트", onAlarm: true, alarm: .init(isWeekRepeat: true, days: [1,2], date: .now, endDate: .now, time: .now)))
//    .environmentObject(PBFormatter())
//}
//
//#Preview("date-endDate") {
//  PocketCell(
//    PocketModel(
//      id: .init(),
//      title: "테스트",
//      onAlarm: true,
//      alarm: .init(
//        isWeekRepeat: true,
//        days: [1,2],
//        date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 20))!,
//        endDate: .now,
//        time: .now
//      )
//    )
//  )
//    .environmentObject(PBFormatter())
//}
//
//#Preview("Template") {
//  PocketCell(TemplateModel(title: "테스트"))
//    .environmentObject(PBFormatter())
//}
