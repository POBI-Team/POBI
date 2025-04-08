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
import NetworkService
import LocalNotiService

struct CreatePocketView: View {
  enum Mode {
    case create
    case edit
  }
  
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @State private var isAppear = false
  @State private var icons = [String]()
  @State private var isDidTapDownButton = false
  @State private var isPresentedEditAlert = false
  @State private var isPresentedOffAlarmAlert = false
  @State private var toastID: UUID? = nil
  @State private var pocket: Pocket
  @FocusState private var isFocused: Bool
  
  private let colors = PBColors.list.colors
  private let mode: Mode
  private let pocketModel: PocketModel?
  
  init(_ mode: Mode, pocket: PocketModel?) {
    self.mode = mode
    self.pocketModel = pocket
    self.pocket = pocket?.temporary() ?? .init()
  }
  
  var body: some View {
    PBNavigationBar {
      PBColors.navy._10.color
        .ignoresSafeArea(.all)
        .pbAlert(isPresented: $isPresentedEditAlert, type: .edit) {
          pocketModel?.deletePushAlarm()
          pocketModel?.paste(pocket)
          if pocket.onAlarm {
            let nickName = ProfileStorage.shared.loadNickname()
            pocketModel?.registerPushAlarm(userNickname: nickName ?? "사용자")
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
                VStack(alignment: .center, spacing: 16) {
                  Button {
                    withAnimation(.default.speed(1.5)) {
                      isDidTapDownButton.toggle()
                      isFocused = false
                    }
                  } label: {
                    PBCircleEmojiView(pocket.icon, size: .xlarge)
                      .foregroundStyle(colors[pocket.colorIndex]._03.color)
                  }
                  TextField(
                    "포켓 이름을 입력해주세요!",
                    text: Binding(
                      get: { pocket.title },
                      set: { pocket.title = $0 }
                    )
                  )
                  .focused($isFocused)
                  .underLine(text: Binding(
                    get: { pocket.title },
                    set: { pocket.title = $0 }
                  ))
                  VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                      LazyHGrid(
                        rows: [GridItem(.flexible())],
                        spacing: 12
                      ) {
                        ForEach(colors.indices, id: \.self) { i in
                          Button {
                            withAnimation {
                              pocket.colorIndex = i
                              isFocused = false
                            }
                          } label: {
                            PBSelectableCircleView(isSelected: pocket.colorIndex == i) {
                              Circle()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(Color.clear)
                                .overlay {
                                  Circle()
                                    .frame(width: 36, height: 36)
                                    .foregroundStyle(colors[i]._01.color)
                                }
                            }
                          }
                        }
                      }
                      .padding(.horizontal, 24)
                    }
                    .frame(height: 72)
                    .background(PBColors.navy._10.color)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                      if icons.isEmpty {
                        ProgressView()
                      } else {
                        LazyHGrid(
                          rows: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                          ],
                          spacing: 12
                        ) {
                          ForEach(icons.indices, id: \.self) { i in
                            Button {
                              withAnimation {
                                pocket.icon = icons[i]
                                isFocused = false
                              }
                            } label: {
                              PBSelectableCircleView(isSelected: pocket.icon == icons[i]) {
                                PBCircleEmojiView(icons[i], size: .medium)
                                  .foregroundStyle(Color.white)
                              }
                            }
                          }
                        }
                        .padding(.vertical, 18)
                        .padding(.horizontal, 24)
                      }
                      
                    }
                    .frame(height: 184)
                    .background(PBColors.navy._10.color)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                  }
                  .disabled(!isDidTapDownButton)
                  .frame(height: isDidTapDownButton ? nil : 0, alignment: .top)
                  .clipped()
                  
                  Button {
                    withAnimation(.default.speed(1.5)) {
                      isDidTapDownButton.toggle()
                      isFocused = false
                    }
                    
                  } label: {
                    isDidTapDownButton ? PBImages.up.image : PBImages.down.image
                  }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 16)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .onAppear {
                  guard !isAppear else { return }
                  Task {
                    do {
                      icons = try await NetworkClient.shared.request(
                        target: FirebaseAPI.icons,
                        of: [String].self
                      )
                      if pocket.icon == nil {
                        pocket.icon = icons.first ?? ""
                      }
                    } catch {
                      #warning("에러 처리")
                    }
                    isAppear = true
                  }
                }
                // MARK: Alarm Toggle
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
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                // MARK: SettingAlarmView
                if pocket.onAlarm {
                  SettingAlarmView(pocket: $pocket, isFocused: _isFocused, isDidTapDownButton: $isDidTapDownButton)
                }
                Spacer()
              }
              .padding(.horizontal, 20)
              .padding(.top, 24)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .animation(.easeInOut, value: pocket.onAlarm)

            PBRoundButton(16) {
              guard !pocket.title.isEmpty else { toastID = .init(); return }
              if mode == .create {
                let newPocketModel = PocketModel(pocket)
                if pocket.onAlarm {
                  let nickName = ProfileStorage.shared.loadNickname()
                  newPocketModel.registerPushAlarm(userNickname: nickName ?? "사용자")
                }
                modelContext.insert(newPocketModel)
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
    .rightItem {
      if mode == .create {
        Button {
          dismiss()
        } label: {
          PBImages.cancel.image
        }
      }
    }
    .leftItem {
      if mode == .edit {
        Button {
          dismiss()
        } label: {
          PBImages.left.image
        }
      }
    }
    .pbToast(toastID: $toastID, message: "포켓 이름을 입력해주세요!", height: 12)
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

#Preview {
  CreatePocketView(.create, pocket: .init(onAlarm: true))
}
