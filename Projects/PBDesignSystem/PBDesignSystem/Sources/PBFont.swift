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
  public typealias title = Title
  public typealias subTitie = SubTitle
  public typealias body = Body
  public typealias button = ButtonFont
  public typealias caption = Caption
  public typealias label = Label
  public typealias tossFace = TossFace
  
  public static func registerFont() {
    PBFontStyle.allCases.forEach {
      guard let url = Bundle.module.url(forResource: "\($0.rawValue)", withExtension: "ttf") else {
        return
      }
      CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
  }
}

private enum PBFontStyle: String, CaseIterable {
  case bold = "Pretendard-Bold"
  case semiBold = "Pretendard-SemiBold"
  case medium = "Pretendard-Medium"
  case tossFace = "TossFaceFontMac"
}

public enum Headline {
  public static var _1: UIFont { .custom(.semiBold, size: 24) }
}

public enum Title {
  public static var _1: UIFont { .custom(.semiBold, size: 20) }
  public static var _2: UIFont { .custom(.semiBold, size: 18) }
}

public enum SubTitle {
  public static var _1: UIFont { .custom(.semiBold, size: 18) }
}

public enum Body {
  public static var _1: UIFont { .custom(.medium, size: 18) }
  public static var _2: UIFont { .custom(.semiBold, size: 16) }
  public static var _3: UIFont { .custom(.medium, size: 16) }
  public static var _4: UIFont { .custom(.medium, size: 14) }
}

public enum ButtonFont {
  public static var _1: UIFont { .custom(.semiBold, size: 18) }
  public static var _2: UIFont { .custom(.semiBold, size: 16) }
  public static var _3: UIFont { .custom(.medium, size: 16) }
}

public enum Caption {
  public static var _1: UIFont { .custom(.semiBold, size: 16) }
  public static var _2: UIFont { .custom(.medium, size: 14) }
}

public enum Label {
  public static var _1: UIFont { .custom(.semiBold, size: 14) }
}

public enum TossFace {
  public static var small: UIFont { .custom(.tossFace, size: 20) }
  public static var medium: UIFont { .custom(.tossFace, size: 23) }
  public static var large: UIFont { .custom(.tossFace, size: 35) }
  public static var xlarge: UIFont { .custom(.tossFace, size: 80) }
}

public extension UIFont {
  fileprivate static func custom(_ weigth: PBFontStyle, size: CGFloat) -> UIFont {
    return UIFont(name: weigth.rawValue, size: size) ?? .systemFont(ofSize: size)
  }
  
  var font: Font {
    return Font(self as CTFont)
  }
}
