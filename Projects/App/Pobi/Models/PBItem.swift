//
//  PBItem.swift
//  Pobi
//
//  Created by 이시원 on 3/30/25.
//

struct PBRecommendedItem: Decodable {
  let vacation: [String]
  let work: [String]
  let health: [String]
  let domesticTravel: [String]
  let overseasTravel: [String]
  let outing: [String]
}
