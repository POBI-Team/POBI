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
}

public extension UIImage {
  var image: Image {
    Image(uiImage: self)
  }
}
