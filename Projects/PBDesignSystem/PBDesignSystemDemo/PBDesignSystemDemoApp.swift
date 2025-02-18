//
//  PBDesignSystemDemoApp.swift
//  PBDesignSystemDemo
//
//  Created by 이시원 on 2/18/25.
//

import SwiftUI

import PBDesignSystem

@main
struct PBDesignSystemDemoApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .onAppear {
          PBFonts.registerFont()
        }
    }
  }
}
