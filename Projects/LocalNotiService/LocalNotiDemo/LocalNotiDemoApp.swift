//
//  LocalNotiDemoApp.swift
//  LocalNotiDemo
//
//  Created by 이시원 on 3/23/25.
//

import SwiftUI

import LocalNotiService

@main
struct LocalNotiDemoApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .onAppear() {
          Task {
            let isSuccess = try await LocalNotiCenter.shared.requestAuthorization(options: [.alert, .sound])
            print(isSuccess)
          }
        }
    }
  }
}
