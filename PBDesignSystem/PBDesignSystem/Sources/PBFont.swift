//
//  PBFont.swift
//  PBDesignSystem
//
//  Created by 이시원 on 2/18/25.
//

import UIKit
import SwiftUI

public enum PBFonts {
  public typealias headline = Headline
  public typealias body = Body
  public typealias caption = Caption
  
  public static func registerFont() {
    PBStyle.allCases.forEach {
      guard let url = Bundle.module.url(forResource: "\($0.rawValue)", withExtension: ".otf") else {
        return
      }
      CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
  }
}

public enum PBStyle: String, CaseIterable {
  case bold = "Pretendard-Bold"
  case semiBold = "Pretendard-SemiBold"
  case medium = "Pretendard-Medium"
}

public enum Headline {
  public static var _1: UIFont { .custom(.bold, size: 24) }
  public static var _2: UIFont { .custom(.semiBold, size: 24) }
}

public enum Body {
  public static var _1: UIFont { .custom(.semiBold, size: 18) }
  public static var _2: UIFont { .custom(.semiBold, size: 16) }
  public static var _3: UIFont { .custom(.semiBold, size: 14) }
}

public enum Caption {
  public static var _1: UIFont { .custom(.medium, size: 14) }
  public static var _2: UIFont { .custom(.medium, size: 12) }
}

public extension UIFont {
  fileprivate static func custom(_ weigth: PBStyle, size: CGFloat) -> UIFont {
    return UIFont(name: weigth.rawValue, size: size) ?? .systemFont(ofSize: size)
  }
  
  var font: Font {
    return Font(self as CTFont)
  }
}
