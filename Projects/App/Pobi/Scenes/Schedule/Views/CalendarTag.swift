//
//  CalendarTag.swift
//  Pobi
//
//  Created by 이시원 on 5/16/25.
//

import SwiftUI

import PBDesignSystem

import PBStorageInterface

struct CalendarTag: View {
  @ObservedObject private var pocket: CDPocketModel
  
  init(pocket: CDPocketModel) {
    self.pocket = pocket
  }
  
  var body: some View {
    RoundedRectangle(cornerRadius: 4)
      .overlay(alignment: .leading) {
        HStack {
          ClippedLabel(text: pocket.title)
        }
        .padding(2)
      }
      .frame(height: 17)
      .foregroundStyle(PBColors.list.colors[Int(pocket.colorIndex)]._02.color)
      .clipped()
  }
}

private struct ClippedLabel: UIViewRepresentable {
  let text: String
  
  func makeUIView(context: Context) -> UILabel {
    let label = UILabel()
    label.numberOfLines = 1
    label.lineBreakMode = .byClipping
    label.font = PBFonts.label._3
    return label
  }
  
  func updateUIView(_ uiView: UILabel, context: Context) {
    uiView.text = text
  }
}

//#Preview {
//  CalendarTag(pocket: .init(title: "이름"))
//    .frame(width: 43)
//}
