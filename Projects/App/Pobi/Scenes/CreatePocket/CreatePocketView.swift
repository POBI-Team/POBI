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

import ComposableArchitecture

struct CreatePocketView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var isDidTapDownButton = false
  @State private var isPresentedEditAlert = false
  @State private var isPresentedTemplateList = false
  @State private var toastID: UUID? = nil
  @FocusState private var isFocused: Bool
  
  @Bindable private var store: StoreOf<CreatePocketFeature>
  
  init(store: StoreOf<CreatePocketFeature>) {
    self.store = store
  }
  
  var body: some View {
    PBNavigationBar {
      PBColors.navy._10.color
        .ignoresSafeArea(.all)
        .pbAlert(isPresented: $isPresentedEditAlert, type: .edit) {
          store.send(.edit)
          dismiss()
        }
        .pbAlert(isPresented: $store.isPresentedOffAlarmAlert.sending(\.setIsPresentedOffAlarmAlert), type: .offAlarm) {
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
                // MARK: Title & Icon
                InputTitleAndIconView(
                  isFocused: $isFocused,
                  isDidTapDownButton: $isDidTapDownButton,
                  pocket: $store.pocket.sending(\.setPocket),
                )
                // MARK: SettingAlarmView
                SettingAlarmView(
                  pocket: $store.pocket.sending(\.setPocket),
                  isFocused: $isFocused,
                  isDidTapDownButton: $isDidTapDownButton
                )
                // MARK: Alarm & Calendar Toggle
                VStack(spacing: 16) {
                  HStack {
                    Toggle(
                      isOn: Binding(
                        get: { store.state.pocket.onAlarm },
                        set: { print($0); store.send(.switchedAlarm($0)) }
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
                      isOn: $store.pocket.isCalendar.sending(\.setOnCalendar)
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
            .animation(.easeInOut, value: store.state.pocket.onAlarm)

            PBRoundButton(16) {
              guard !store.state.pocket.title.isEmpty else { toastID = .init(); return }
              if store.state.pocketModel == nil {
                store.send(.create)
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
        .onChange(of: store.state.pocket.onAlarm) { _, newValue in
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
        if store.state.pocketModel == nil {
          PBImages.cancel.image
        } else {
          PBImages.left.image
        }
      }
    }
    .rightItem {
      if store.state.pocketModel == nil {
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
      TemplateList(
        selectedTemplate: $store.selectedTemplate.sending(\.setTemplate)
      )
    }
  }
}

//#Preview("Edit") {
//  CreatePocketView(
//    store: Store(initialState: CreatePocketFeature.State(pocket: .init(onAlarm: true))) {
//      CreatePocketFeature()
//    }
//  )
//  .environmentObject(PBFormatter())
//}
//
//#Preview("Create") {
//  CreatePocketView(
//    store: Store(initialState: CreatePocketFeature.State(pocket: nil, date: .now)) {
//      CreatePocketFeature()
//    }
//  )
//  .environmentObject(PBFormatter())
//}
