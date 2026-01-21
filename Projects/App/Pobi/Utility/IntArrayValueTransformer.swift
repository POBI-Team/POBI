//
//  IntArrayValueTransformer.swift
//  Pobi
//
//  Created by 이시원 on 12/17/25.
//

import Foundation

class IntArrayValueTransformer: NSSecureUnarchiveFromDataTransformer {
  override static var allowedTopLevelClasses: [AnyClass] { [
    NSArray.self,
    NSNumber.self,
    NSData.self
  ] }
  
  static func register() {
    let className = String(describing: IntArrayValueTransformer.self)
    let name = NSValueTransformerName(className)
    let transformer = IntArrayValueTransformer()
    
    ValueTransformer.setValueTransformer(transformer, forName: name)
  }
}
