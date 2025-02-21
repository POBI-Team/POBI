//
//  PobiApp.swift
//  Pobi
//
//  Created by 이시원 on 2/15/25.
//

import SwiftUI

import PBDesignSystem

@main
struct PobiApp: App {
  init() {
    PBFonts.registerFont()
  }
  
  var body: some Scene {
    WindowGroup {
      PocketList()
    }
  }
}
