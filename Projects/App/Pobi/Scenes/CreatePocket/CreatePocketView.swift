//
//  CreatePocketView.swift
//  Pobi
//
//  Created by 이시원 on 3/4/25.
//

import SwiftUI

import PBDesignSystem
import PBStorage
import PBStorageInterface
import LocalNotiService

struct CreatePocketView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var profileStorage: ProfileStorage
  @State private var isDidTapDownButton = false
  @State private var isPresentedEditAlert = false
  @State private var isPresentedOffAlarmAlert = false
  @State private var isPresentedTemplateList = false
  @State private var toastID: UUID? = nil
  @State private var pocket: Pocket
  @State private var selectedTemplate: TemplateModel?
  @FocusState private var isFocused: Bool
  
  private let pocketModel: PocketModel?
  
  init(pocket: PocketModel?, date: Date? = nil) {
    self.pocketModel = pocket
    self.pocket = pocket?.temporary() ?? Pocket(
      isCalendar: date != nil,
      alarm: Alarm(date: date ?? .now)
    )
  }
  
  var body: some View {
    PBNavigationBar {
      PBColors.navy._10.color
        .ignoresSafeArea(.all)
        .pbAlert(isPresented: $isPresentedEditAlert, type: .edit) {
          pocketModel?.deletePushAlarm()
          pocketModel?.paste(pocket)
          if pocket.onAlarm {
            let nickName = profileStorage.loadNickname()
            pocketModel?.registerPushAlarm(userNickname: nickName ?? "사용자")
            FirebaseManager.shared.logEvent(event: .alarmActivation)
          } else {
            FirebaseManager.shared.logEvent(event: .alarmDisable)
          }
          dismiss()
        }
        .pbAlert(isPresented: $isPresentedOffAlarmAlert, type: .offAlarm) {
          if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
              UIApplication.shared.open(url)
            }
          }
        }
        .overlay {
          VStack {
            ScrollView {
              VStack(spacing: 12) {
                InputTitleAndIconView(
                  isFocused: $isFocused,
                  isDidTapDownButton: $isDidTapDownButton,
                  pocket: $pocket
                )
                // MARK: SettingAlarmView
                SettingAlarmView(pocket: $pocket, isFocused: _isFocused, isDidTapDownButton: $isDidTapDownButton)
                // MARK: Alarm & Calendar Toggle
                VStack(spacing: 16) {
                  HStack {
                    Toggle(
                      isOn: Binding(
                        get: { pocket.onAlarm },
                        set: { setOnAlarm(valeu: $0) }
                      )
                    ) {
                      Text("알림")
                        .font(PBFonts.body._2.font)
                        .foregroundStyle(PBColors.navy._900.color)
                    }
                    .tint(PBColors.yellow._500.color)
                  }
                  
                  HStack {
                    Toggle(
                      isOn: Binding(
                        get: { pocket.isCalendar },
                        set: { pocket.isCalendar = $0 }
                      )
                    ) {
                      Text("캘린더에 표시")
                        .font(PBFonts.body._2.font)
                        .foregroundStyle(PBColors.navy._900.color)
                    }
                    .tint(PBColors.yellow._500.color)
                  }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
              }
              .padding(.horizontal, 20)
              .padding(.top, 24)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .animation(.easeInOut, value: pocket.onAlarm)
            .onChange(of: selectedTemplate) { oldValue, newValue in
              if let template = newValue {
                pocket.title = template.title
                pocket.icon = template.icon
              }
            }

            PBRoundButton(16) {
              guard !pocket.title.isEmpty else { toastID = .init(); return }
              if pocketModel == nil {
                let newPocketModel = PocketModel(pocket)
                if pocket.onAlarm {
                  let nickName = profileStorage.loadNickname()
                  newPocketModel.registerPushAlarm(userNickname: nickName ?? "사용자")
                  FirebaseManager.shared.logEvent(event: .alarmActivation)
                } else {
                  FirebaseManager.shared.logEvent(event: .alarmDisable)
                }
                if pocket.isCalendar {
                  FirebaseManager.shared.logEvent(event: .onCalendar)
                } else {
                  FirebaseManager.shared.logEvent(event: .offCalendar)
                }
                if let template = selectedTemplate {
                  newPocketModel.items = template.items.map { $0.copy() }
                  FirebaseManager.shared.logEvent(event: .importTemplate)
                }
                modelContext.insert(newPocketModel)
                FirebaseManager.shared.logEvent(event: .createPocket)
                dismiss()
              } else {
                isPresentedEditAlert.toggle()
              }
            } label: {
              Text("완료")
                .foregroundStyle(.white)
                .font(PBFonts.button._1.font)
            }
            .foregroundStyle(PBColors.navy._900.color)
            .frame(height: 52)
            .padding([.horizontal, .bottom], 14)
          }
        }
        .onChange(of: pocket.onAlarm) { _, newValue in
          withAnimation {
            isFocused = false
            isDidTapDownButton = false
          }
        }
    }
    .leftItem {
      Button {
        dismiss()
      } label: {
        if pocketModel == nil {
          PBImages.cancel.image
        } else {
          PBImages.left.image
        }
      }
    }
    .rightItem {
      if pocketModel == nil {
        Button {
          isPresentedTemplateList = true
        } label: {
          Text("템플릿")
            .foregroundStyle(PBColors.yellow._600.color)
            .font(PBFonts.button._1.font)
        }
      }
    }
    .pbToast(toastID: $toastID, message: "포켓 이름을 입력해주세요!", height: 12)
    .fullScreenCover(isPresented: $isPresentedTemplateList) {
      TemplateList(selectedTemplate: $selectedTemplate)
    }
  }
}

private extension CreatePocketView {
  func setOnAlarm(valeu: Bool) {
    if valeu {
      Task {
        if await LocalNotiCenter.shared.isOnAlarm() {
          pocket.onAlarm = valeu
        } else {
          isPresentedOffAlarmAlert = true
        }
      }
    } else {
      pocket.onAlarm = valeu
    }
  }
}

#Preview("Edit") {
  CreatePocketView(pocket: .init(onAlarm: true))
    .environmentObject(PBFormatter())
}

#Preview("Create") {
  CreatePocketView(pocket: nil)
    .environmentObject(PBFormatter())
}
