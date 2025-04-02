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
    VStack(alignment: .leading) {
      Spacer()
        .frame(height: 16)
      PBCircleEmojiView(pocket.icon, size: .small)
        .foregroundStyle(colors[pocket.colorIndex]._01.color)
        .frame(width: 32, height: 32)
        .padding(.leading, 16)
      Spacer()
      VStack(alignment: .leading, spacing: 4) {
        Text(pocket.title)
          .font(PBFonts.title._2.font)
          .foregroundStyle(PBColors.navy._900.color)
        Text(timeLabel)
          .font(PBFonts.label._1.font)
          .foregroundStyle(PBColors.navy._400.color)
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
  var timeLabel: String {
    let alarmTime = pocket.alarm.time
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR") // 한국 로케일 설정
    formatter.dateFormat = "a h:mm" // "오전/오후 시:분" 형태
    return formatter.string(from: alarmTime)
  }
}

#Preview {
  PocketCell(.init(id: .init(), title: "테스트"))
}
