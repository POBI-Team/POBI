//
//  PobiApp.swift
//  Pobi
//
//  Created by 이시원 on 2/15/25.
//

import UIKit
import SwiftUI

import PBDesignSystem

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
  open override func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}

@main
struct PobiApp: App {  
  init() {
    PBFonts.registerFont()
  }
  
  var body: some Scene {
    WindowGroup {
      SplashView()
    }
  }
}
