//
//  PBImages.swift
//  PBDesignSystem
//
//  Created by 이시원 on 2/21/25.
//
import UIKit
import SwiftUI

public struct PBImages {
  public static var plus: UIImage { UIImage(named: "plus", in: .module, with: nil)! }
  public static var next: UIImage { UIImage(named: "next", in: .module, with: nil)! }
  public static var manu16: UIImage { UIImage(named: "manu_16", in: .module, with: nil)! }
  public static var clock: UIImage { UIImage(named: "clock", in: .module, with: nil)! }
  public static var deactivateCheckBox: UIImage { UIImage(named: "deactivate_checkBox", in: .module, with: nil)! }
  public static var uncheckedCheckBox: UIImage { UIImage(named: "unchecked_checkBox", in: .module, with: nil)! }
  public static var checkedCheckBox: UIImage { UIImage(named: "checked_checkBox", in: .module, with: nil)! }
  public static var back: UIImage { UIImage(named: "back", in: .module, with: nil)! }
  public static var manu24: UIImage { UIImage(named: "manu_24", in: .module, with: nil)! }
}

public extension UIImage {
  var image: Image {
    Image(uiImage: self)
  }
}
