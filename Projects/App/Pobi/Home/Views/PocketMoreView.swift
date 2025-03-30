//
//  PocketMoreView.swift
//  Pobi
//
//  Created by 이시원 on 3/30/25.
//

import SwiftUI

import PBDesignSystem

struct PocketMoreView: View {
  var body: some View {
    PBColors.navy._10.color
      .overlay {
        Capsule()
          .frame(width: 36, height: 5)
      }
  }
}

#Preview {
  PocketMoreView()
}
