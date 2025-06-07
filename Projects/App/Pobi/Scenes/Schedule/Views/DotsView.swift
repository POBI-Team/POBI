//
//  DotsView.swift
//  Pobi
//
//  Created by 이시원 on 6/7/25.
//

import SwiftUI

import PBDesignSystem
import PBStorageInterface

struct DotsView: View {
  private let pockets: [PocketModel]
  private let dotLimit: Int
  
  init(width: CGFloat?, pockets: [PocketModel]) {
    self.pockets = pockets
    self.dotLimit = Int(((width ?? 0)+4)/10)
  }
  
  var body: some View {
    HStack(alignment: .center, spacing: 4) {
      ForEach(0..<min(dotLimit, pockets.count), id: \.self) { i in
        RoundedRectangle(cornerRadius: 1)
          .foregroundStyle(PBColors.list.colors[pockets[i].colorIndex]._02.color)
          .frame(width: 6, height: 6)
      }
    }
  }
}
