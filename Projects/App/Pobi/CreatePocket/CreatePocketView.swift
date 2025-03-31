//
//  CreatePocketView.swift
//  Pobi
//
//  Created by 이시원 on 3/4/25.
//

import SwiftUI
import SwiftData

import PBDesignSystem
import PBStorage
import PBStorageInterface
import NetworkService
import LocalNotiService

struct CreatePocketView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  
  @State private var icons = [String]()
  @State private var isSelectedDate: Bool = false
  @State private var isSelectedTime: Bool = false
  @State private var isDidTapDownButton: Bool = false
  @State private var isPresentedDataSelectView: Bool = false
  @State private var selectedDate: Date = .now
  @State private var selectedTime: Date = .now
  @State private var selectedDays: String = "매일"
  @State private var pocket: PocketModel = PocketModel(
    id: .init(),
    title: ""
  )
  
  private let colors = PBColors.list.colors
  
  var body: some View {
    PBNavigationBar {
      ScrollView {
        VStack(spacing: 12) {
          VStack(alignment: .center, spacing: 16) {
            PBCircleEmojiView(pocket.icon, size: .xlarge)
              .foregroundStyle(colors[pocket.colorIndex]._01.color)
            PBTitleTextField(
              text: $pocket.title,
              placeholder: "포켓 이름을 입력해주세요!"
            )
            
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
                          withAnimation {
                            pocket.icon = icons[i]
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
            Toggle(isOn: $pocket.onAlarm) {
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
              PBAlarmSegmentControl(isRepeated: $pocket.repeats)
              HStack {
                Text(pocket.repeats ? "반복" : "날짜")
                  .font(PBFonts.body._2.font)
                Spacer()
                if pocket.repeats {
                  Button {
                    isPresentedDataSelectView.toggle()
                  } label: {
                    HStack(alignment: .center, spacing: 8) {
                      Text(
                        selectedDays.isEmpty ? "요일 혹은 날짜를 선택해주세요" : selectedDays
                      )
                      .font(PBFonts.caption._1.font)
                      .foregroundStyle(PBColors.navy._300.color)
                      .lineLimit(1)
                      .frame(minHeight: 34)
                      PBImages.right.image
                    }
                  }
                } else {
                  PBRoundButton(10) {
                    withAnimation {
                      isSelectedDate.toggle()
                    }
                  } label: {
                    Text(dateLable)
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
                    selection: $selectedDate,
                    displayedComponents: .date
                  )
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
                  }
                } label: {
                  Text(timeLable)
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
                    selection: $selectedTime,
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
        .padding(.bottom, 70)
        .padding(.top, 24)
      }
      .scrollDismissesKeyboard(.interactively)
      .background(PBColors.navy._10.color)
      .animation(.easeInOut, value: pocket.onAlarm)
      .overlay {
        VStack {
          Spacer()
          PBRoundButton(16) {
            if pocket.onAlarm {
              let dateString: String
              if pocket.repeats {
                dateString = selectedDays
              } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-M-d"
                dateString = dateFormatter.string(from: selectedDate)
              }
              pocket.alarm = PocketAlarmModel(date: dateString, time: selectedTime)
              if pocket.onAlarm {
                registerPushAlarm()
              }              
            }
            modelContext.insert(pocket)
            dismiss()
          } label: {
            Text("설정")
              .foregroundStyle(.white)
              .font(PBFonts.body._1.font)
          }
          .foregroundStyle(PBColors.navy._900.color)
          .frame(height: 48)
          .padding([.horizontal, .bottom], 20)
        }
      }
      .sheet(isPresented: $isPresentedDataSelectView) {
        DateSelectView(date: $selectedDays)
        .presentationDetents([.medium])
      }
      .onChange(of: pocket.repeats, { _, _ in
        withAnimation {
          isSelectedDate = false
        }
      })
      .onAppear {
        Task {
          do {
            icons = try await NetworkClient.shared.request(
              target: FirebaseAPI.icons,
              of: [String].self
            )
            pocket.icon = icons.first ?? ""
          } catch {
            #warning("에러 처리")
          }
        }
      }
    }
    .rightItem {
      Button {
        dismiss()
      } label: {
        PBImages.cancel.image
      }
    }
  }
}

private extension CreatePocketView {
  var dateLable: String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = "M월 d일"
    return dateFormatter.string(from: selectedDate)
  }
  
  var timeLable: String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "h:mm a"
    return dateFormatter.string(from: selectedTime)
  }
  
  func registerPushAlarm() {
    let triggerType: TrigerType
    if pocket.repeats {
      guard let splitedDate = pocket.alarm?.date
        .split(separator: " ") else { return }
      switch splitedDate[0] {
      case "매주":
        let weeks: [TrigerType.Weekday] = splitedDate[1]
            .components(separatedBy: ", ")
            .compactMap { .weekday(string: $0) }
        triggerType = .week(weeks: weeks)
      case "매월":
        let days = splitedDate[1]
            .components(separatedBy: ", ")
            .compactMap { UInt($0) }
        triggerType = .day(days: days)
      case "매일":
        triggerType = .week(weeks: TrigerType.Weekday.allCases)
      default: return
      }
    } else {
      guard let splitedDate = pocket.alarm?.date
        .split(separator: "-").compactMap({ UInt($0) }) else { return }
      triggerType = .date(
        year: splitedDate[0],
        month: splitedDate[1],
        day: splitedDate[2]
      )
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH-m"
    let splitedTime = dateFormatter
      .string(from: selectedTime)
      .split(separator: "-")
      .compactMap({ UInt($0) })
#warning("사용자 닉네임")
    LocalNotiCenter.shared.register(
      title: "POBI",
      body: "똑똑! XX님 '\(pocket.title)' 소지품 챙기세요!",
      id: pocket.id.uuidString,
      trigerType: triggerType,
      hour: splitedTime[0],
      minute: splitedTime[1]
    )
  }
}

#Preview {
  CreatePocketView()
}
