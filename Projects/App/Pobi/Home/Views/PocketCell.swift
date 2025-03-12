//
//  PocketCell.swift
//  Pobi
//
//  Created by 이시원 on 2/19/25.
//

import SwiftUI

import PBDesignSystem

struct PocketCell: View {
  private let title: String
  private let listColor: PBListColor.Type
  
  init (
    title: String,
    listColor: PBListColor.Type
  ) {
    self.title = title
    self.listColor = listColor
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Spacer()
        .frame(height: 16)
      PBCircleEmojiView()
        .foregroundStyle(listColor._01.color)
        .frame(width: 32, height: 32)
        .padding(.leading, 16)
      Spacer()
      VStack(alignment: .leading, spacing: 5) {
        Text(title)
          .font(PBFonts.body._1.font)
          .foregroundStyle(PBColors.navy._900.color)
        Text("Hello, world!")
          .font(PBFonts.caption._2.font)
          .foregroundStyle(PBColors.navy._400.color)
      }
      .padding(.horizontal, 16)
      Spacer()
      HStack {
        Text("Hello, world!")
          .font(PBFonts.caption._2.font)
          .foregroundStyle(PBColors.navy._900.color)
        Spacer()
        PBImages.next.image
      }
      .padding(.leading, 16)
      .padding(.trailing, 12)
      .frame(height: 40)
      .background(listColor._02.color)
      .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    .background(listColor._03.color)
    .clipShape(RoundedRectangle(cornerRadius: 20))
    .aspectRatio(1, contentMode: .fit)
    .overlay(alignment: .top) {
      HStack {
        Spacer()
        Button {
          
        } label: {
          PBImages.manu16.image
        }
      }
      .padding(.top, 20)
      .padding(.trailing, 12)
    }
  }
}

#Preview {
  PocketCell(title: "Test", listColor: PBColors.list.yellow.self)
}
