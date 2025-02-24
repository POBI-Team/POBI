//
//  PocketDetailView.swift
//  Pobi
//
//  Created by 이시원 on 2/21/25.
//

import SwiftUI

import PBDesignSystem

struct PocketDetailView: View {
  private let colorType: PBListColor.Type
  
  init(colorType: PBListColor.Type) {
    self.colorType = colorType
  }
  
  var body: some View {
    ScrollView {
      VStack(spacing: 25) {
        HStack {
          VStack(alignment: .leading) {
            Text("Pocket Detail")
              .font(PBFonts.headline._2.font)
              .foregroundStyle(PBColors.navy._900.color)
            HStack(spacing: 2) {
              PBImages.clock.image
              Text("Pocket Detail")
                .font(PBFonts.caption._2.font)
                .foregroundStyle(PBColors.navy._400.color)
            }
          }
          Spacer()
          PBCircleEmojiView()
            .frame(width: 60, height: 60)
            .foregroundStyle(colorType._01.color)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 24)
        .background(colorType._03.color)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        ObjectList()
        Spacer()
      }
      .padding(.top, 16)
      .padding(.horizontal, 20)
      .navigationBarBackButtonHidden()
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button(action: {
            
          }) {
            PBImages.back.image
          }
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button(action: {
            
          }) {
            PBImages.manu24.image
          }
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    PocketDetailView(colorType: PBColors.list.red.self)
  }
}
