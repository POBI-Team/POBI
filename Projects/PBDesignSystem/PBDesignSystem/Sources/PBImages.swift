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
  public static var right: UIImage { UIImage(named: "right", in: .module, with: nil)! }
  public static var clock: UIImage { UIImage(named: "clock", in: .module, with: nil)! }
  public static var deactivateCheckBox: UIImage { UIImage(named: "deactivate_checkBox", in: .module, with: nil)! }
  public static var uncheckedCheckBox: UIImage { UIImage(named: "unchecked_checkBox", in: .module, with: nil)! }
  public static var checkedCheckBox: UIImage { UIImage(named: "checked_checkBox", in: .module, with: nil)! }
  public static var left: UIImage { UIImage(named: "left", in: .module, with: nil)! }
  public static var manu: UIImage { UIImage(named: "manu", in: .module, with: nil)! }
  public static var down: UIImage { UIImage(named: "down", in: .module, with: nil)! }
  public static var up: UIImage { UIImage(named: "up", in: .module, with: nil)! }
  public static var setting: UIImage { UIImage(named: "setting", in: .module, with: nil)! }
  public static var cancel: UIImage { UIImage(named: "cancel", in: .module, with: nil)! }
  public static var like: UIImage { UIImage(named: "like", in: .module, with: nil)! }
  public static var mail: UIImage { UIImage(named: "mail", in: .module, with: nil)! }
  public static var trash: UIImage { UIImage(named: "trash", in: .module, with: nil)! }
  public static var pobiInquiry: UIImage { UIImage(named: "pobi_inquiry", in: .module, with: nil)! }
}

public extension UIImage {
  var image: Image {
    Image(uiImage: self)
  }
}
