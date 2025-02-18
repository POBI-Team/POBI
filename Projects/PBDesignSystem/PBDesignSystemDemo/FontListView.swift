//
//  FontListView.swift
//  PBDesignSystem
//
//  Created by 이시원 on 2/18/25.
//

import SwiftUI

import PBDesignSystem

struct FontListView: View {
  var body: some View {
    List {
      Section("Headline") {
        Text("Headline_1").font(PBFonts.headline._1.font)
        Text("Headline_2").font(PBFonts.headline._2.font)
      }
      
      Section("Body") {
        Text("Body_1").font(PBFonts.body._1.font)
        Text("Body_2").font(PBFonts.body._2.font)
        Text("Body_3").font(PBFonts.body._3.font)
      }
      
      Section("Caption") {
        Text("Caption_1").font(PBFonts.caption._1.font)
        Text("Caption_2").font(PBFonts.caption._2.font)
      }
    }
    .navigationTitle("Fonts")
  }
}

#Preview {
  FontListView()
}
