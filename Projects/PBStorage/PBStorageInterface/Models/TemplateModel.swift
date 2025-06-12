//
//  TemplateModel.swift
//  PBStorage
//
//  Created by 이시원 on 6/11/25.
//

import SwiftData

@Model
public final class TemplateModel {
  @Attribute(.unique) public var id: UUID
  public var title: String
  public var colorIndex: Int = 7
  public var icon: String?
  @Relationship(deleteRule: .cascade) public var items: [PocketItemModel]
  public var createAt: Date
  
  public init(
    id: UUID = UUID(),
    title: String = "",
    icon: String? = nil,
    items: [PocketItemModel] = [],
    createAt: Date = .now
  ) {
    self.id = id
    self.title = title
    self.icon = icon
    self.items = items
    self.createAt = createAt
  }
  
  public convenience init(_ template: Template) {
    self.init(title: template.title, icon: template.icon)
  }
  
  public func temporary() -> Template {
    return Template(
      title: self.title,
      icon: self.icon,
    )
  }
  
  public func paste(_ template: Template) {
    self.title = template.title
    self.colorIndex = template.colorIndex
    self.icon = template.icon
  }
}

public struct Template: Pocketable {
  public var title: String
  public var icon: String?
  public var colorIndex: Int = 7

  public init(
    title: String = "",
    icon: String? = nil,
  ) {
    self.title = title
    self.icon = icon
  }
}
