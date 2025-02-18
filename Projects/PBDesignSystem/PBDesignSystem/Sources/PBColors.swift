//
//  PBColors.swift
//  PBDesignSystem
//
//  Created by 이시원 on 2/18/25.
//

import UIKit
import SwiftUI

public enum PBColors {
  public static var red: UIColor { UIColor(hexString: "FF5A5A") }
  public static var white: UIColor { UIColor(hexString: "FFFFFF") }
  public typealias navy = Navy
  public typealias yellow = Yellow
  public typealias list = List
}

public enum List {
  public typealias red = RedList
  public typealias blue = BlueList
  public typealias yellow = YellowList
  public typealias purple = PurpleList
  public typealias green = GreenList
  public typealias pink = PinkList
  public typealias mint = MintList
  public typealias gray = GrayList
}

public enum Navy {
  public static var _900: UIColor { UIColor(hexString: "141437") }
  public static var _800: UIColor { UIColor(hexString: "20224E") }
  public static var _700: UIColor { UIColor(hexString: "262B5A") }
  public static var _600: UIColor { UIColor(hexString: "2E3464") }
  public static var _500: UIColor { UIColor(hexString: "343A6C") }
  public static var _400: UIColor { UIColor(hexString: "4F557F") }
  public static var _300: UIColor { UIColor(hexString: "6B7194") }
  public static var _200: UIColor { UIColor(hexString: "9398B2") }
  public static var _100: UIColor { UIColor(hexString: "BCC0D2") }
  public static var _50: UIColor { UIColor(hexString: "E5E6EC") }
}

public enum Yellow {
  public static var _900: UIColor { UIColor(hexString: "F56929") }
  public static var _800: UIColor { UIColor(hexString: "F7872D") }
  public static var _700: UIColor { UIColor(hexString: "F99830") }
  public static var _600: UIColor { UIColor(hexString: "FBA931") }
  public static var _500: UIColor { UIColor(hexString: "FDB634") }
  public static var _400: UIColor { UIColor(hexString: "FEC045") }
  public static var _300: UIColor { UIColor(hexString: "FFCC5F") }
  public static var _200: UIColor { UIColor(hexString: "FFDA8A") }
  public static var _100: UIColor { UIColor(hexString: "FFE8B7") }
  public static var _50: UIColor { UIColor(hexString: "FFF6E3") }
}

public enum RedList {
  public static var _01: UIColor { UIColor(hexString: "FFB9BE") }
  public static var _02: UIColor { UIColor(hexString: "FFD2D7") }
  public static var _03: UIColor { UIColor(hexString: "FFF0F0") }
}

public enum BlueList {
  public static var _01: UIColor { UIColor(hexString: "AADCFF") }
  public static var _02: UIColor { UIColor(hexString: "C3E6FF") }
  public static var _03: UIColor { UIColor(hexString: "EBF5FF") }
}

public enum YellowList {
  public static var _01: UIColor { UIColor(hexString: "FFD764") }
  public static var _02: UIColor { UIColor(hexString: "FFE696") }
  public static var _03: UIColor { UIColor(hexString: "FFFAE1") }
}

public enum PurpleList {
  public static var _01: UIColor { UIColor(hexString: "BEBEFA") }
  public static var _02: UIColor { UIColor(hexString: "D7D7FF") }
  public static var _03: UIColor { UIColor(hexString: "F0F0FF") }
}

public enum GreenList {
  public static var _01: UIColor { UIColor(hexString: "B4E1A0") }
  public static var _02: UIColor { UIColor(hexString: "D2F0BE") }
  public static var _03: UIColor { UIColor(hexString: "F0FAE6") }
}

public enum PinkList {
  public static var _01: UIColor { UIColor(hexString: "FFC3FF") }
  public static var _02: UIColor { UIColor(hexString: "FFD2FF") }
  public static var _03: UIColor { UIColor(hexString: "FFEBFF") }
}

public enum MintList {
  public static var _01: UIColor { UIColor(hexString: "A5E6E1") }
  public static var _02: UIColor { UIColor(hexString: "BEF0EB") }
  public static var _03: UIColor { UIColor(hexString: "E6FAF5") }
}

public enum GrayList {
  public static var _01: UIColor { UIColor(hexString: "DCDCE1") }
  public static var _02: UIColor { UIColor(hexString: "E6E6EB") }
  public static var _03: UIColor { UIColor(hexString: "F5F5F7") }
}

public extension UIColor {
  convenience init(hexString: String, opacity: Double = 1.0) {
    let hex: Int = Int(hexString, radix: 16) ?? 0
    let red = Double((hex >> 16) & 0xff) / 255
    let green = Double((hex >> 8) & 0xff) / 255
    let blue = Double((hex >> 0) & 0xff) / 255
    
    self.init(red: red, green: green, blue: blue, alpha: opacity)
  }
  
  var color: Color {
    return Color(uiColor: self)
  }
}
