//
//  ObjectList.swift
//  Pobi
//
//  Created by 이시원 on 2/21/25.
//

import SwiftUI

import PBDesignSystem

struct ObjectList: View {
  @State var title: String = ""
  @State var memo: String = ""
  var body: some View {
    VStack(alignment: .leading, spacing: 21) {
      Text("ObjectList")
        .font(PBFonts.body._1.font)
        .foregroundStyle(PBColors.navy._100.color)
        .padding(.leading, 8)
      LazyVStack(spacing: 24) {
        PBCheckBoxTextField(title: $title, memo: $memo)
        PBCheckBoxTextField(title: $title, memo: $memo)
      }
    }
  }
}

#Preview {
  ObjectList()
}
