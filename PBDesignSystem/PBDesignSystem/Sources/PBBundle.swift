//
//  PBBundle.swift
//  PBDesignSystem
//
//  Created by 이시원 on 2/18/25.
//

private class PBBundle {}

extension Foundation.Bundle {
  static let module: Bundle = Bundle(for: PBBundle.self)
}
