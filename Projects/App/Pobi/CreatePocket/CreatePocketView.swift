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

struct CreatePocketView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  
  @State private var icons = [String]()
  @State private var pocket: PocketModel = PocketModel(
    id: .init(),
    title: ""
  )
  @State private var isSelectedDate: Bool = false
  @State private var isSelectedTime: Bool = false
  @State private var isDidTapDownButton: Bool = false
  @State private var isRepeated: Bool = false
  @State private var isPresentedDataSelectView: Bool = false
  
  private let colors = PBColors.list.colors
  
  var body: some View {
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
              HStack(spacing: 8) {
                Spacer()
                ForEach(colors.indices, id: \.self) { i in
                  Circle()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(colors[i]._01.color)
                }
                Spacer()
              }
              .padding(.vertical, 18)
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
          }
          .tint(PBColors.yellow._500.color)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        
        VStack(alignment: .center, spacing: 16) {
          PBAlarmSegmentControl(isRepeated: $isRepeated)
          HStack {
            Text(isRepeated ? "반복" : "날짜")
            Spacer()
            if isRepeated {
              Button {
                isPresentedDataSelectView.toggle()
              } label: {
                HStack(alignment: .center, spacing: 8) {
                  Text("매주 월, 화, 수, 목, 금, 토, 일")
                    .font(PBFonts.caption._1.font)
                    .foregroundStyle(PBColors.navy._300.color)
                    .lineLimit(1)
                    .frame(minWidth: 115, minHeight: 34)
                  PBImages.next.image
                }
              }
              .sheet(isPresented: $isPresentedDataSelectView) {
                DateSelectView()
                  .presentationDetents([.medium])
              }
            } else {
              PBRoundButton(10) {
                withAnimation {
                  isSelectedDate.toggle()
                }
              } label: {
                Text("12월 10일")
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
                selection: .constant(Date()),
                displayedComponents: .date
              )
              .datePickerStyle(.graphical)
              Divider()
            }
          }
          
          HStack {
            Text("시간")
            Spacer()
            PBRoundButton(10) {
              withAnimation {
                isSelectedTime.toggle()
              }
            } label: {
              Text("12:00 AM")
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
                selection: .constant(Date()),
                displayedComponents: .hourAndMinute
              )
              .datePickerStyle(.wheel)
              Divider()
            }
          }
        }
        .padding(.horizontal, 16)
        .padding([.vertical], 16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .opacity(pocket.onAlarm ? 1 : 0)
        .animation(.default, value: pocket.onAlarm)
        Spacer()
      }
      .padding(.horizontal, 20)
      .padding(.bottom, 50)
    }
    .background(PBColors.navy._10.color)
    .overlay {
      VStack {
        Spacer()
        PBCapsuleButton("저장") {
          modelContext.insert(pocket)
          dismiss()
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 20)
      }
    }
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button(action: {
          dismiss()
        }) {
          PBImages.back.image
        }
      }
    }
    .onAppear {
      Task {
        do {
          icons = try await NetworkClient.shared.request(
            target: FirebaseAPI.icons,
            of: [String].self
          )
          pocket.icon = icons.first ?? ""
        } catch {
          print(error.localizedDescription)
        }
      }
    }
  }
}

#Preview {
  CreatePocketView()
}
