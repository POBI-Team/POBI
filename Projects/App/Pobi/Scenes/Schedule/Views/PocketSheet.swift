//
//  PocketSheet.swift
//  Pobi
//
//  Created by 이시원 on 5/30/25.
//

import SwiftUI

import PBCalendar
import PBDesignSystem
import PBStorageInterface

import ComposableArchitecture

struct PocketSheet: View {
  @Environment(\.modelContext) private var modelContext
  @EnvironmentObject private var formatter: PBFormatter
  @Binding private var item: PBCalendarItem?
  @Binding private var isEditMode: Bool
  private let minHeight: CGFloat
  
  @State private var isPresentedDeleteAlert: Bool = false

  init(
    item: Binding<PBCalendarItem?>,
    isEditMode: Binding<Bool>,
    minHeight: CGFloat
  ) {
    self._item = item
    self._isEditMode = isEditMode
    self.minHeight = minHeight
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Divider()
        .foregroundStyle(PBColors.navy._10.color)
      
      VStack(spacing: 0) {
        VStack(spacing: 8) {
          Capsule()
            .frame(width: 36, height: 5)
            .foregroundStyle(PBColors.navy._50.color)
          HStack {
            Text(dateLabel)
              .font(PBFonts.title._2.font)
              .foregroundStyle(PBColors.navy._900.color)
            Spacer()
            Button {
              if #available(iOS 18.0, *) {
                withAnimation {
                  isEditMode.toggle()
                }
              } else {
                isEditMode.toggle()
              }
            } label: {
              Text(isEditMode ? "완료" : "편집")
                .font(PBFonts.button._2.font)
            }
            .tint(PBColors.navy._900.color)
            .disabled(item?.pockets.isEmpty ?? true)
          }
        }
        .contentShape(Rectangle())
        .padding(.bottom, 24)
        
        ScrollView {
          LazyVStack(spacing: 12) {
            ForEach(item?.pockets ?? [], id: \.id) { pocket in
              HStack(spacing: 8) {
                NavigationLink {
                  if isEditMode {
                    CreatePocketView(
                      store: Store(initialState: CreatePocketFeature.State(pocket: pocket)) {
                        CreatePocketFeature()
                      }
                    )
                  } else {
                    PocketDetailView(pocket)
                  }
                } label: {
                  HStack(spacing: 0) {
                    if let icon = pocket.icon, !isEditMode {
                      Text(icon)
                        .font(PBFonts.tossFace.xsmall.font)
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 8)
                    }
                    
                    if isEditMode {
                      PBImages.setting.image
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 8)
                    }
                    
                    Text(pocket.title)
                      .lineLimit(1)
                      .font(PBFonts.body._2.font)
                      .foregroundStyle(PBColors.navy._900.color)
                      .padding(.trailing, 12)
                    if !isEditMode {
                      Text(timeLabel(time: pocket.alarm.time))
                        .font(PBFonts.label._2.font)
                        .foregroundStyle(PBColors.navy._900.color)
                    }
                    Spacer()
                    if !isEditMode {
                      PBShapes.arrow(direction: .right)
                        .frame(width: 14, height: 7)
                        .foregroundStyle(PBColors.navy._900.color)
                    }
                  }
                  .frame(height: 48)
                  .padding(.horizontal, 16)
                  .background(PBColors.list.colors[pocket.colorIndex]._03.color)
                  .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                if isEditMode {
                  Button {
                    isPresentedDeleteAlert = true
                  } label: {
                    RoundedRectangle(cornerRadius: 12)
                      .overlay {
                        PBImages.trash.image
                          .renderingMode(.template)
                          .foregroundStyle(.white)
                      }
                  }
                  .frame(width: 48, height: 48)
                  .tint(PBColors.red.color)
                  .pbAlert(isPresented: $isPresentedDeleteAlert, type: .delete) {
                    pocket.deletePushAlarm()
                    item?.pockets.removeAll { $0.id == pocket.id }
                    modelContext.delete(pocket)
                    try? modelContext.save()
                  }
                }
              }
            }
          }
        }
        .frame(minHeight: minHeight - 77)
        .overlay {
          if item?.pockets.isEmpty == true {
            VStack(spacing: 8) {
              Text("포켓이 텅 비었어요!")
                .font(PBFonts.title._1.font)
                .foregroundStyle(PBColors.navy._900.color)
              Text("오른쪽 상단의 ‘+’ 버튼을 눌러 포켓을 생성하고,\n소지품 리스트를 작성해주세요")
                .lineSpacing(4)
                .multilineTextAlignment(.center)
                .font(PBFonts.body._4.font)
                .foregroundStyle(PBColors.navy._200.color)
            }
          }
        }
      }
      .padding(.horizontal, 20)
      .padding(.top, 12)
    }
  }
}

extension PocketSheet {
  func timeLabel(time: Date) -> String {
    formatter.label(time, format: "a h:mm", locale: Locale(identifier: "ko_KR"))
  }
  
  var dateLabel: String {
    guard let item,
          let month = item.dateComponents.month,
          let day = item.dateComponents.day,
          let weekday = formatter.weekDay(item.dateComponents.weekday ?? 0) else { return "날짜를 선택해주세요" }
    return "\(month)월 \(day)일 \(weekday)"
  }
}

#if DEBUG
#Preview {
  @Previewable @State var item: PBCalendarItem? = PBCalendarItem(
    id: "test",
    dateComponents: .init(),
    isToday: false,
    isInCurrentMonth: true,
    pockets: [
      PocketModel(title: "Test1", colorIndex: 0, icon: "❤️"),
      PocketModel(title: "Test2", colorIndex: 1, icon: "❤️"),
      PocketModel(title: "Test3", colorIndex: 2, icon: "❤️")
    ]
  )
  @Previewable @State var isEditMode: Bool = false
  
  NavigationStack {
    PocketSheet(
      item: $item,
      isEditMode: $isEditMode,
      minHeight: 300.0
    )
      .environmentObject(PBFormatter())
  }
}
#endif
