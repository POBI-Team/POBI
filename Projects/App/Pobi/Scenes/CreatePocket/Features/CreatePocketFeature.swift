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
    var selectedTemplate: TemplateModel?
    
    init(pocket: PocketModel?, date: Date? = nil) {
      self.pocketModel = pocket
      self.pocket = pocket?.temporary() ?? Pocket(
        isCalendar: date != nil,
        alarm: Alarm(date: date ?? .now)
      )
    }
  }
  
  enum Action {
    case setTitle(String)
    case setOnAlarm(Bool)
    case setTemplate(TemplateModel)
    case edit
    case create
  }
  
  @Dependency(\.profileStorage) var profileStorage
  @Dependency(\.localNotiCenter) var localNotiCenter
  @Dependency(\.firebaseManager) var firebaseManager
  @Dependency(\.pocketStorage) var pocketStorage
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .setTitle(let title):
        state.pocket.title = title
      case .setOnAlarm(let onAlarm):
        state.pocket.onAlarm = onAlarm
      case .setTemplate(let template):
        state.selectedTemplate = template
        return .merge(.send(.setTitle(template.title)))
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
      case .create:
        let newPocketModel = PocketModel(state.pocket)
        if state.pocket.onAlarm {
          let nickName = profileStorage.loadNickname() ?? "사용자"
          localNotiCenter.register(
            title: "POBI",
            body: "똑똑! \(nickName)님 '\(newPocketModel.title)' 소지품 챙기세요!",
            id: newPocketModel.id.uuidString,
            trigerType: newPocketModel.pushType,
            time: newPocketModel.alarm.time
          )
          firebaseManager.logEvent(event: .alarmActivation)
        } else {
          firebaseManager.logEvent(event: .alarmDisable)
        }
        if state.pocket.isCalendar {
          firebaseManager.logEvent(event: .onCalendar)
        } else {
          firebaseManager.logEvent(event: .offCalendar)
        }
        if let template = state.selectedTemplate {
          newPocketModel.items = template.items.map { $0.copy() }
          firebaseManager.logEvent(event: .importTemplate)
        }
        pocketStorage?.insert(newPocketModel)
        firebaseManager.logEvent(event: .createPocket)
      }
      return .none
    }
  }
}
