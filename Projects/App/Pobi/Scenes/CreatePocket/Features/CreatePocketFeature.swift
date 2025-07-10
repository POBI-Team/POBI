//
//  CreatePocketFeature.swift
//  Pobi
//
//  Created by 이시원 on 7/8/25.
//

import PBStorageInterface

import ComposableArchitecture

@Reducer
struct CreatePocketFeature {
  
  @ObservableState
  struct State: Equatable {
    var pocket: Pocket = .init()
    let pocketModel: PocketModel?
    
    init(pocket: PocketModel?, date: Date? = nil) {
      self.pocketModel = pocket
      self.pocket = pocket?.temporary() ?? Pocket(
        isCalendar: date != nil,
        alarm: Alarm(date: date ?? .now)
      )
    }
  }
  
  enum Action {
    case titleChanged(String)
    case onAlarmChanged(Bool)
    case edit
  }
  
  @Dependency(\.profileStorage) var profileStorage
  @Dependency(\.localNotiCenter) var localNotiCenter
  @Dependency(\.firebaseManager) var firebaseManager
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .titleChanged(let title):
        state.pocket.title = title
      case .onAlarmChanged(let onAlarm):
        state.pocket.onAlarm = onAlarm
      case .edit:
        guard let pocketModel = state.pocketModel else { return .none }
        localNotiCenter.remove(id: pocketModel.id.uuidString, type: pocketModel.pushType)
        pocketModel.paste(state.pocket)
        if state.pocket.onAlarm {
          let nickName = profileStorage.loadNickname() ?? "사용자"
          localNotiCenter.register(
            title: "POBI",
            body: "똑똑! \(nickName)님 '\(pocketModel.title)' 소지품 챙기세요!",
            id: pocketModel.id.uuidString,
            trigerType: pocketModel.pushType,
            time: pocketModel.alarm.time
          )
          firebaseManager.logEvent(event: .alarmActivation)
        } else {
          firebaseManager.logEvent(event: .alarmDisable)
        }
      }
      return .none
    }
  }
}
