//
//  ContentView.swift
//  PBDesignSystemDemo
//
//  Created by 이시원 on 2/18/25.
//

import SwiftUI

import PBDesignSystem

struct ColorPaletteView: View {
  var body: some View {
    List {
      Section(header: Text("Red")) {
        ColorCell(
          color: PBColors.red.color,
          text: Text("Red")
        )
      }
      Section(header: Text("White")) {
        ColorCell(
          color: PBColors.white.color,
          text: Text("White")
        )
      }
      Section(header: Text("Navy")) {
        ColorCell(
          color: PBColors.navy._900.color,
          text: Text("900").foregroundStyle(.white)
        )
        ColorCell(
          color: PBColors.navy._800.color,
          text: Text("800").foregroundStyle(.white)
        )
        ColorCell(
          color: PBColors.navy._700.color,
          text: Text("700").foregroundStyle(.white)
        )
        ColorCell(
          color: PBColors.navy._600.color,
          text: Text("600").foregroundStyle(.white)
        )
        ColorCell(
          color: PBColors.navy._500.color,
          text: Text("500").foregroundStyle(.white)
        )
        ColorCell(
          color: PBColors.navy._400.color,
          text: Text("400")
        )
        ColorCell(
          color: PBColors.navy._300.color,
          text: Text("300")
        )
        ColorCell(
          color: PBColors.navy._200.color,
          text: Text("200")
        )
        ColorCell(
          color: PBColors.navy._100.color,
          text: Text("100")
        )
        ColorCell(
          color: PBColors.navy._50.color,
          text: Text("50")
        )
      }
      .listRowSeparator(.hidden)
      
      Section(header: Text("Yellow")) {
        ColorCell(
          color: PBColors.yellow._900.color,
          text: Text("900").foregroundStyle(.white)
        )
        ColorCell(
          color: PBColors.yellow._800.color,
          text: Text("800").foregroundStyle(.white)
        )
        ColorCell(
          color: PBColors.yellow._700.color,
          text: Text("700").foregroundStyle(.white)
        )
        ColorCell(
          color: PBColors.yellow._600.color,
          text: Text("600").foregroundStyle(.white)
        )
        ColorCell(
          color: PBColors.yellow._500.color,
          text: Text("500").foregroundStyle(.white)
        )
        ColorCell(
          color: PBColors.yellow._400.color,
          text: Text("400")
        )
        ColorCell(
          color: PBColors.yellow._300.color,
          text: Text("300")
        )
        ColorCell(
          color: PBColors.yellow._200.color,
          text: Text("200")
        )
        ColorCell(
          color: PBColors.yellow._100.color,
          text: Text("100")
        )
        ColorCell(
          color: PBColors.yellow._50.color,
          text: Text("50")
        )
      }
      .listRowSeparator(.hidden)
      
      Section(header: Text("List")) {
        ColorCell(
          color: PBColors.list.red._01.color,
          text: Text("red01")
        )
        ColorCell(
          color: PBColors.list.red._02.color,
          text: Text("red02")
        )
        ColorCell(
          color: PBColors.list.red._03.color,
          text: Text("red03")
        )
        
        ColorCell(
          color: PBColors.list.blue._01.color,
          text: Text("blue01")
        )
        ColorCell(
          color: PBColors.list.blue._02.color,
          text: Text("blue02")
        )
        ColorCell(
          color: PBColors.list.blue._03.color,
          text: Text("blue03")
        )
        
        ColorCell(
          color: PBColors.list.yellow._01.color,
          text: Text("yellow01")
        )
        ColorCell(
          color: PBColors.list.yellow._02.color,
          text: Text("yellow02")
        )
        ColorCell(
          color: PBColors.list.yellow._03.color,
          text: Text("yellow03")
        )
        
        ColorCell(
          color: PBColors.list.purple._01.color,
          text: Text("purple01")
        )
        ColorCell(
          color: PBColors.list.purple._02.color,
          text: Text("purple02")
        )
        ColorCell(
          color: PBColors.list.purple._03.color,
          text: Text("purple03")
        )
        
        ColorCell(
          color: PBColors.list.green._01.color,
          text: Text("green01")
        )
        ColorCell(
          color: PBColors.list.green._02.color,
          text: Text("green02")
        )
        ColorCell(
          color: PBColors.list.green._03.color,
          text: Text("green03")
        )
        
        ColorCell(
          color: PBColors.list.pink._01.color,
          text: Text("pink01")
        )
        ColorCell(
          color: PBColors.list.pink._02.color,
          text: Text("pink02")
        )
        ColorCell(
          color: PBColors.list.pink._03.color,
          text: Text("pink03")
        )
        
        ColorCell(
          color: PBColors.list.mint._01.color,
          text: Text("mint01")
        )
        ColorCell(
          color: PBColors.list.mint._02.color,
          text: Text("mint02")
        )
        ColorCell(
          color: PBColors.list.mint._03.color,
          text: Text("mint03")
        )
        
        ColorCell(
          color: PBColors.list.gray._01.color,
          text: Text("gray01")
        )
        ColorCell(
          color: PBColors.list.gray._02.color,
          text: Text("gray02")
        )
        ColorCell(
          color: PBColors.list.gray._03.color,
          text: Text("gray03")
        )
      }
      .listRowSeparator(.hidden)
    }
    .navigationTitle("Colors")
  }
}

#Preview {
  ColorPaletteView()
}
