//
//  PocketMoreView.swift
//  Pobi
//
//  Created by 이시원 on 3/30/25.
//

import SwiftUI

import PBDesignSystem
import PBStorageInterface
import LocalNotiService

struct PocketMoreView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  private let pocket: PocketModel
  
  init(_ pokcet: PocketModel) {
    self.pocket = pokcet
  }
  
  var body: some View {
    PBColors.navy._10.color
      .ignoresSafeArea(.all)
      .overlay {
        VStack(spacing: 0) {
          Capsule()
            .foregroundStyle(PBColors.navy._50.color)
            .frame(width: 36, height: 5)
          VStack(spacing: 1) {
            Button {
              dismiss()
            } label: {
              HStack(spacing: 8) {
                PBImages.setting.image
                Text("수정하기")
                  .foregroundStyle(PBColors.navy._900.color)
                  .font(PBFonts.button._1.font)
                Spacer()
              }
              .padding(.horizontal, 20)
              .padding(.vertical, 14)
            }
            .background(.white)
            
            Button {
              dismiss()
            } label: {
              HStack(spacing: 8) {
                PBImages.copy.image
                Text("복제하기")
                  .foregroundStyle(PBColors.navy._900.color)
                  .font(PBFonts.button._1.font)
                Spacer()
              }
              .padding(.horizontal, 20)
              .padding(.vertical, 14)
            }
            .background(.white)
            
            Button {
              dismiss()
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                pocket.isHidden.toggle()
              }
            } label: {
              HStack(spacing: 8) {
                if pocket.isHidden {
                  PBImages.eyeOn.image
                } else {
                  PBImages.eyeOff.image
                }
                Text(pocket.isHidden ? "포켓 숨기기 해제" : "포켓 숨기기")
                  .foregroundStyle(PBColors.navy._900.color)
                  .font(PBFonts.button._1.font)
                Spacer()
              }
              .padding(.horizontal, 20)
              .padding(.vertical, 14)
            }
            .background(.white)
            
            Button {
              dismiss()
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                #warning("해당 부분 Create와 중복 코드")
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
                LocalNotiCenter.shared.remove(id: pocket.id.uuidString, type: triggerType)
                modelContext.delete(pocket)
              }
            } label: {
              HStack(spacing: 8) {
                PBImages.trash.image
                Text("삭제하기")
                  .foregroundStyle(PBColors.red.color)
                  .font(PBFonts.button._1.font)
                Spacer()
              }
              .padding(.horizontal, 20)
              .padding(.vertical, 14)
            }
            .background(.white)
          }
          .clipShape(RoundedRectangle(cornerRadius: 16))
          .padding(.top, 27)
          
          PBRoundButton(16) {
            dismiss()
          } label: {
            Text("닫기")
              .foregroundStyle(PBColors.navy._900.color)
              .font(PBFonts.button._1.font)
          }
          .frame(height: 52)
          .foregroundStyle(.white)
          .padding(.top, 19)
          Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
      }
      .presentationDetents([.height(331)])
  }
}

#Preview {
  Color.white
    .sheet(
      isPresented: .constant(true),
      content: {
        PocketMoreView(.init(id: .init(), title: "테스트"))
      })
}
