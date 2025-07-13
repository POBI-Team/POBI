//
//  MockPocketStorage.swift
//  PBStorage
//
//  Created by 이시원 on 7/13/25.
//

import PBStorageInterface

public final class MockPocketStorage: PocketStorageInterface, @unchecked Sendable {
  public struct CallCount {
    public var read: Int = 0
    public var insert: Int = 0
    public var delete: Int = 0
  }
  
  public struct ReturnValue {
    public var read: [any PocketModelable] = []
  }
  
  public struct InputValue {
    public var insert: (any PocketModelable)?
    public var delete: (any PocketModelable)?
  }
  
  public var callCount: CallCount = .init()
  public var returnValue: ReturnValue = .init()
  public var inputValue: InputValue = .init()
  
  public init() {}
  
  public func read<T>(_ type: T.Type, sortBy sorts: [SortDescriptor<T>], filter: Predicate<T>?) throws -> [T] where T : PocketModelable {
    callCount.read += 1
    return returnValue.read.map { $0 as! T }
  }
  
  public func insert<T>(_ model: T) where T : PocketModelable {
    callCount.insert += 1
    inputValue.insert = model
  }
  
  public func delete<T>(_ model: T) where T : PocketModelable {
    callCount.delete += 1
    inputValue.delete = model
  }
}
