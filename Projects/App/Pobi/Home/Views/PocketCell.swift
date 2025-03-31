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
      VStack(alignment: .leading, spacing: 5) {
        Text(pocket.title)
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
          isPresentedPocketMore = true
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

#Preview {
  PocketCell(.init(id: .init(), title: "테스트"))
}
