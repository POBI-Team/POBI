//
//  MockFirebaseManager.swift
//  Pobi
//
//  Created by 이시원 on 7/9/25.
//

@testable import Pobi

final class MockFirebaseManager: FirebaseManagerInterface, @unchecked Sendable {
  
  func logEvent(event: Pobi.EventType) {}
  
  func logEvent(event: Pobi.EventType, parameters: [String : Any]) {}
}
