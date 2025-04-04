//
//  PocketCell.swift
//  Pobi
//
//  Created by 이시원 on 2/19/25.
//

import SwiftUI

import PBDesignSystem
import PBStorageInterface

struct PocketCell: View {
  private let pocket: PocketModel
  private let colors = PBColors.list.colors
  @State private var isPresentedPocketMore = false
  @State private var isPresentedCreate = false
  
  init (
    _ pocket: PocketModel
  ) {
    self.pocket = pocket
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Spacer()
        .frame(height: 16)
      VStack(alignment: .leading, spacing: 10) {
        PBCircleEmojiView(pocket.icon, size: .small)
          .foregroundStyle(.white)
          .frame(width: 36, height: 36)
        VStack(alignment: .leading, spacing: 6) {
          Text(pocket.title)
            .lineLimit(1)
            .font(PBFonts.title._2.font)
            .foregroundStyle(PBColors.navy._900.color)
          Text(alarmLabel)
            .font(PBFonts.label._1.font)
            .lineLimit(1)
            .foregroundStyle(PBColors.navy._400.color)
        }
      }
      .padding(.horizontal, 16)
      Spacer()
      HStack {
        Text("\(pocket.items.count) itmes")
          .font(PBFonts.caption._2.font)
          .foregroundStyle(PBColors.navy._900.color)
        Spacer()
        PBImages.right.image
      }
      .padding(.leading, 16)
      .padding(.trailing, 12)
      .frame(height: 40)
      .background(colors[pocket.colorIndex]._02.color)
      .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    .sheet(isPresented: $isPresentedPocketMore) {
      PocketMoreView(pocket, isPresentedCreate: $isPresentedCreate)
    }
    .background(colors[pocket.colorIndex]._03.color)
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
    .navigationDestination(isPresented: $isPresentedCreate) {
      CreatePocketView(.edit, pocket: pocket)
    }
  }
}

private extension PocketCell {
  var alarmLabel: String {
    if pocket.onAlarm {
      if pocket.repeats {
        return PBFormatter.shared.label(isWeekDay: pocket.alarm.isWeekRepeat, days: pocket.alarm.days)
      }
      return PBFormatter.shared.label(pocket.alarm.date, format: "M월 d일")
    }
    return ""
  }
}

#Preview("week") {
  PocketCell(.init(id: .init(), title: "테스트", onAlarm: true, repeats: true, alarm: .init(isWeekRepeat: true, days: [1,2,3,4,5,6], date: .now, time: .now)))
}

#Preview("day") {
  PocketCell(.init(id: .init(), title: "테스트", onAlarm: true, repeats: true, alarm: .init(isWeekRepeat: false, days: [1,2], date: .now, time: .now)))
}

#Preview("date") {
  PocketCell(.init(id: .init(), title: "테스트", onAlarm: true, alarm: .init(isWeekRepeat: true, days: [1,2], date: .now, time: .now)))
}
