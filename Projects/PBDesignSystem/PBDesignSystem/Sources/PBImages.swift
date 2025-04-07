//
//  PBImages.swift
//  PBDesignSystem
//
//  Created by 이시원 on 2/21/25.
//
import UIKit
import SwiftUI

public struct PBImages {
  public static var plus36: UIImage { UIImage(named: "plus_36", in: .module, with: nil)! }
  public static var plus16: UIImage { UIImage(named: "plus_16", in: .module, with: nil)! }
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
  public static var settingFill: UIImage { UIImage(named: "setting_fill", in: .module, with: nil)! }
  public static var cancel: UIImage { UIImage(named: "cancel", in: .module, with: nil)! }
  public static var like: UIImage { UIImage(named: "like", in: .module, with: nil)! }
  public static var mail: UIImage { UIImage(named: "mail", in: .module, with: nil)! }
  public static var trash: UIImage { UIImage(named: "trash", in: .module, with: nil)! }
  public static var pobiInquiry: UIImage { UIImage(named: "pobi_inquiry", in: .module, with: nil)! }
  public static var pobiAlert: UIImage { UIImage(named: "pobi_alert", in: .module, with: nil)! }
  public static var pobiEmpty: UIImage { UIImage(named: "pobi_empty", in: .module, with: nil)! }
  public static var pen: UIImage { UIImage(named: "pen", in: .module, with: nil)! }
  public static var copy: UIImage { UIImage(named: "copy", in: .module, with: nil)! }
  public static var eyeOff: UIImage { UIImage(named: "eye_off", in: .module, with: nil)! }
  public static var eyeOn: UIImage { UIImage(named: "eye_on", in: .module, with: nil)! }
  public static var lamp: UIImage { UIImage(named: "lamp", in: .module, with: nil)! }
  public static var slide: UIImage { UIImage(named: "slide", in: .module, with: nil)! }
  public static var logo: UIImage { UIImage(named: "logo", in: .module, with: nil)! }
  public static var onboardingFirst: UIImage { UIImage(named: "onboarding_first", in: .module, with: nil)! }
  public static var onboardingSecond: UIImage { UIImage(named: "onboarding_second", in: .module, with: nil)! }
  public static var onboardingThird: UIImage { UIImage(named: "onboarding_third", in: .module, with: nil)! }
  public static var profileFirst: UIImage { UIImage(named: "profile_first", in: .module, with: nil)! }
  public static var profileSecond: UIImage { UIImage(named: "profile_second", in: .module, with: nil)! }
  public static var edit: UIImage { UIImage(named: "edit", in: .module, with: nil)! }
  public static var warning: UIImage { UIImage(named: "warning", in: .module, with: nil)! }
  public static var warningCycle: UIImage { UIImage(named: "warning_cycle", in: .module, with: nil)! }
  public static var pobiHiddenEmpty: UIImage { UIImage(named: "pobi_hidden_empty", in: .module, with: nil)! }
}

public extension UIImage {
  var image: Image {
    Image(uiImage: self)
  }
}
