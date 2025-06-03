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

struct PocketSheet: View {
  @EnvironmentObject private var formatter: PBFormatter
  @Binding private var height: CGFloat
  @Binding private var item: PBCalendarItem?
  @GestureState private var offset: CGFloat = 0
  
  let date: Date
  let totalHeight: CGFloat
  init(
    date: Date,
    height: Binding<CGFloat>,
    item: Binding<PBCalendarItem?>,
    totalHeight: CGFloat
  ) {
    self._item = item
    self._height = height
    self.date = date
    self.totalHeight = totalHeight
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
              
            } label: {
              Text("편집")
                .font(PBFonts.button._2.font)
            }
            .tint(PBColors.navy._900.color)
          }
        }
        .onChange(of: offset) { oldValue, newValue in
          height -= newValue
        }
        .contentShape(Rectangle())
        .gesture(
          DragGesture()
            .updating($offset) { value, state, _ in
              state = value.translation.height
            }
            .onEnded { _ in
              if height < totalHeight * 0.25 {
                withAnimation {
                  height = 0
                }
              } else if height > totalHeight * 0.75 {
                withAnimation {
                  height = totalHeight
                }
              } else {
                withAnimation {
                  height = totalHeight / 2
                }
              }
            }
        )
        
        .padding(.bottom, 24)
        ScrollView {
          LazyVStack(spacing: 12) {
            ForEach(item?.pockets ?? [], id: \.id) { pocket in
              NavigationLink {
                PocketDetailView(pocket)
              } label: {
                HStack(spacing: 0) {
                  if let icon = pocket.icon {
                    Text(icon)
                      .font(PBFonts.tossFace.xsmall.font)
                      .padding(.trailing, 8)
                  }
                  Text(pocket.title)
                    .font(PBFonts.body._2.font)
                    .foregroundStyle(PBColors.navy._900.color)
                    .padding(.trailing, 12)
                  Text(timeLabel(time: pocket.alarm.time))
                    .font(PBFonts.label._2.font)
                    .foregroundStyle(PBColors.navy._900.color)
                  Spacer()
                  PBShapes.arrow(direction: .right)
                    .frame(width: 14, height: 7)
                    .foregroundStyle(PBColors.navy._900.color)
                }
                .padding(16)
                .background(PBColors.list.colors[pocket.colorIndex]._03.color)
                .clipShape(RoundedRectangle(cornerRadius: 12))
              }
            }
          }
        }
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
    guard let item else { return "날짜를 선택해주세요" }
    return formatter.label(date, format: "M월", locale: Locale(identifier: "ko_KR")) + " \(item.day)일 " + (formatter.weekDay(item.weekday) ?? "")
  }
}

#if DEBUG
#Preview {
  @Previewable @State var item: PBCalendarItem? = PBCalendarItem(
    id: "test",
    day: 10,
    weekday: 1,
    isToday: false,
    isInCurrentMonth: true,
    pockets: [
      PocketModel(title: "Test1", colorIndex: 0, icon: "❤️"),
      PocketModel(title: "Test2", colorIndex: 1, icon: "❤️"),
      PocketModel(title: "Test3", colorIndex: 2, icon: "❤️")
    ]
  )
  @Previewable @State var height: CGFloat = 300
  
  GeometryReader { geometry in
    VStack(spacing: 0) {
      TabView {
        Text("1")
        Text("2")
        Text("3")
      }
      .background(Color.red)
      .tabViewStyle(.page(indexDisplayMode: .never))
      if height != 0 {
        PocketSheet(date: .now, height: $height, item: $item, totalHeight: geometry.size.height)
          .environmentObject(PBFormatter())
          .frame(height: height, alignment: .top)
          .clipped()
      }
    }
  }
}
#endif
