//
//  PobiApp.swift
//  Pobi
//
//  Created by 이시원 on 2/15/25.
//

import SwiftUI

import PBDesignSystem
import PBStorage

import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct PobiApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  
  init() {
    PBFonts.registerFont()
  }
  
  var body: some Scene {
    WindowGroup {
      HomeView()
        .modelContainer(try! PocketStorage().modelContainer)
    }
  }
}
