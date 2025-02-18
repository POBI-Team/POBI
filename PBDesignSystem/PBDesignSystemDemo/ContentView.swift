//
//  ContentView.swift
//  PBDesignSystemDemo
//
//  Created by 이시원 on 2/18/25.
//

import SwiftUI

import PBDesignSystem

struct ContentView: View {
  var body: some View {
    NavigationStack {
      List {
        NavigationLink("Color Palette") {
          ColorPaletteView()
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
