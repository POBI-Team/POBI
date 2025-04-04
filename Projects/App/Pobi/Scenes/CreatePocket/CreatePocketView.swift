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
  @State private var isSelectedDate = false
  @State private var isSelectedTime = false
  @State private var isDidTapDownButton = false
  @State private var isPresentedDataSelectView = false
  @State private var isPresentedEditAlert = false
  @State private var isPresentedOffAlarmAlert = false
  @FocusState private var isFocused: Bool
  
  private let colors = PBColors.list.colors
  private let mode: Mode
  private let pocket: PocketModel
  
  init(_ mode: Mode, pocket: PocketModel) {
    self.mode = mode
    self.pocket = pocket
  }
  
  var body: some View {
    PBNavigationBar {
      PBColors.navy._10.color
        .ignoresSafeArea(.all)
        .overlay {
          VStack {
            ScrollView {
              VStack(spacing: 12) {
                VStack(alignment: .center, spacing: 16) {
                  Button {
                    withAnimation {
                      isDidTapDownButton.toggle()
                      isFocused = false
                      isSelectedDate = false
                      isSelectedTime = false
                    }
                  } label: {
                    PBCircleEmojiView(pocket.icon, size: .xlarge)
                      .foregroundStyle(colors[pocket.colorIndex]._01.color)
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
                  if isDidTapDownButton {
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
                              GridItem(.flexible()),
                              GridItem(.flexible())
                            ],
                            spacing: 12
                          ) {
                            ForEach(icons.indices, id: \.self) { i in
                              Button {
                                withAnimation(.easeIn.speed(2.5)) {
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
                      .frame(height: 232)
                      .background(PBColors.navy._10.color)
                      .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                  }
                  
                  Button {
                    withAnimation {
                      isDidTapDownButton.toggle()
                      isFocused = false
                      isSelectedDate = false
                      isSelectedTime = false
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
                
                HStack {
                  Toggle(
                    isOn: Binding(
                      get: { pocket.onAlarm },
                      set: { pocket.onAlarm = $0 }
                    )
                  ) {
                    Text("알림")
                      .font(PBFonts.body._2.font)
                  }
                  .tint(PBColors.yellow._500.color)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                if pocket.onAlarm {
                  VStack(alignment: .center, spacing: 16) {
                    PBAlarmSegmentControl(
                      isRepeated: Binding(
                        get: { pocket.repeats },
                        set: { pocket.repeats = $0 }
                      )
                    )
                    HStack {
                      Text(pocket.repeats ? "반복" : "날짜")
                        .font(PBFonts.body._2.font)
                      Spacer()
                      if pocket.repeats {
                        Button {
                          isPresentedDataSelectView.toggle()
                        } label: {
                          HStack(spacing: 8) {
                            Spacer()
                            Text(repeatLabel)
                              .font(PBFonts.caption._1.font)
                              .foregroundStyle(PBColors.navy._300.color)
                              .lineLimit(1)
                            PBImages.right.image
                          }
                          .frame(maxWidth: 125)
                          .frame(height: 34)
                        }
                      } else {
                        PBRoundButton(10) {
                          withAnimation {
                            isSelectedDate.toggle()
                            isDidTapDownButton = false
                            isFocused = false
                            isSelectedTime = false
                          }
                        } label: {
                          Text(dateLabel)
                            .font(PBFonts.caption._1.font)
                            .foregroundStyle(PBColors.navy._900.color)
                        }
                        .frame(width: 84, height: 34)
                        .foregroundStyle(PBColors.navy._50.color)
                      }
                    }
                    
                    if isSelectedDate {
                      VStack {
                        Divider()
                        DatePicker(
                          "",
                          selection: Binding(get: {
                            pocket.alarm.date
                          }, set: {
                            pocket.alarm.date = $0
                          }),
                          displayedComponents: .date
                        )
                        .tint(PBColors.yellow._500.color)
                        .datePickerStyle(.graphical)
                        .environment(\.locale, Locale(identifier: Locale.preferredLanguages[0]))
                        Divider()
                      }
                    }
                    
                    HStack {
                      Text("시간")
                        .font(PBFonts.body._2.font)
                      Spacer()
                      PBRoundButton(10) {
                        withAnimation {
                          isSelectedTime.toggle()
                          isSelectedDate = false
                          isDidTapDownButton = false
                          isFocused = false
                        }
                      } label: {
                        Text(timeLabel)
                          .font(PBFonts.caption._1.font)
                          .foregroundStyle(PBColors.navy._900.color)
                      }
                      .frame(width: 84, height: 34)
                      .foregroundStyle(PBColors.navy._50.color)
                    }
                    
                    if isSelectedTime {
                      VStack {
                        Divider()
                        DatePicker(
                          "",
                          selection: Binding(get: {
                            pocket.alarm.time
                          }, set: {
                            pocket.alarm.time = $0
                          }),
                          displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.wheel)
                        .frame(width: 221)
                        Divider()
                      }
                    }
                  }
                  .padding(.horizontal, 16)
                  .padding([.vertical], 16)
                  .background(.white)
                  .clipShape(RoundedRectangle(cornerRadius: 20))
                  .animation(.default, value: pocket.onAlarm)
                }
                Spacer()
              }
              .padding(.horizontal, 20)
              .padding(.top, 24)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .animation(.easeInOut, value: pocket.onAlarm)
            .onChange(of: pocket.repeats, { _, _ in
              withAnimation {
                isSelectedDate = false
              }
            })
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
            PBRoundButton(16) {
              if mode == .create {
                if pocket.onAlarm {
                  let nickName = ProfileStorage.shared.loadNickname()
                  pocket.registerPushAlarm(userNickname: nickName ?? "사용자")
                }
                modelContext.insert(pocket)
                try? modelContext.save()
                dismiss()
              } else {
                isPresentedEditAlert.toggle()
              }
            } label: {
              Text("저장")
                .foregroundStyle(.white)
                .font(PBFonts.body._1.font)
            }
            .foregroundStyle(PBColors.navy._900.color)
            .frame(height: 52)
            .padding([.horizontal, .bottom], 14)
          }
          .onTapGesture {
            isFocused = false
          }
        }
        .pbAlert(isPresented: $isPresentedEditAlert, type: .edit) {
          pocket.deletePushAlarm()
          if pocket.onAlarm {
            let nickName = ProfileStorage.shared.loadNickname()
            pocket.registerPushAlarm(userNickname: nickName ?? "사용자")
          }
          try? modelContext.save()
          dismiss()
        }
        .pbAlert(isPresented: $isPresentedOffAlarmAlert, type: .offAlarm) {
          if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
              UIApplication.shared.open(url)
            }
          }
        }
        .onChange(of: pocket.onAlarm) { _, newValue in
          withAnimation {
            isFocused = false
            isDidTapDownButton = false
          }
          if newValue {
            Task {
              let isOnAlarm = await LocalNotiCenter.shared.isOnAlarm()
              isPresentedOffAlarmAlert = !isOnAlarm
              pocket.onAlarm = isOnAlarm
            }
          }
        }
        .sheet(isPresented: $isPresentedDataSelectView) {
          DateSelectView(pocket: pocket)
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
          modelContext.rollback()
          dismiss()
        } label: {
          PBImages.left.image
        }
      }
    }
  }
}

private extension CreatePocketView {
  var dateLabel: String {
    PBFormatter.shared.label(pocket.alarm.date, format: "M월 d일")
  }
  
  var timeLabel: String {
    PBFormatter.shared.label(pocket.alarm.time, format: "h:mm a")
  }
  
  var repeatLabel: String {
    PBFormatter.shared.label(isWeekDay: pocket.alarm.isWeekRepeat, days: pocket.alarm.days)
  }
}

#Preview {
  CreatePocketView(.create, pocket: .init(onAlarm: true))
}
