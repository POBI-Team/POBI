//
//  TemplateModel.swift
//  PBStorage
//
//  Created by 이시원 on 6/11/25.
//

public struct Template: Pocketable {
  public var title: String
  public var icon: String
  public var colorIndex: Int = 7

  public init(
    title: String = "",
    icon: String? = nil,
  ) {
    self.title = title
    self.icon = icon ?? "❤️"
  }
}
