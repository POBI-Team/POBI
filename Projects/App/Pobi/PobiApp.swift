//
//  PobiApp.swift
//  Pobi
//
//  Created by 이시원 on 2/15/25.
//

import SwiftUI

import PBDesignSystem
import PBStorage
import LocalNotiService

@main
struct PobiApp: App {  
  init() {
    PBFonts.registerFont()
  }
  
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        HomeView()
          .onAppear {
            Task {
              try await LocalNotiCenter.shared.requestAuthorization(options: [.alert, .sound])
            }
          }
          .modelContainer(try! PocketStorage().modelContainer)
      }
    }
  }
}
