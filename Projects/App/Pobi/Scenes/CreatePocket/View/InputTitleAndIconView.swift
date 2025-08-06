//
//  InputTitleAndIconView.swift
//  Pobi
//
//  Created by 이시원 on 6/11/25.
//

import SwiftUI

import PBDesignSystem
import PBStorageInterface
import NetworkService

struct InputTitleAndIconView<P: Pocketable>: View {
  @FocusState.Binding var isFocused: Bool
  @Binding private var pocket: P
  @Binding private var isDidTapDownButton: Bool
  @State private var icons = [String]()

  private let colors = PBColors.list.colors
  
  init(
    isFocused: FocusState<Bool>.Binding,
    isDidTapDownButton: Binding<Bool>,
    pocket: Binding<P>
  ) {
    self._isFocused = isFocused
    self._isDidTapDownButton = isDidTapDownButton
    self._pocket = pocket
  }
  
  var body: some View {
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
        pocket is Pocket ? "포켓 이름" : "템플릿 이름",
        text: Binding {
          pocket.title
        } set: {
          pocket.title = $0.trimmingCharacters(in: .whitespaces)
        }
      )
      .focused($isFocused)
      .underLine(text: $pocket.title)
      VStack {
        if pocket is Pocket {
          ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(
              rows: [GridItem(.flexible())],
              spacing: 12
            ) {
              ForEach(0..<colors.count - 1, id: \.self) { i in
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
        }
        
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
        PBShapes.arrow(
          lineWidht: 2.5,
          direction: isDidTapDownButton ? .top : .bottom
        )
        .foregroundStyle(PBColors.navy._100.color)
        .frame(width: 30, height: 12)
      }
    }
    .padding(.horizontal, 24)
    .padding(.top, 20)
    .padding(.bottom, 16)
    .background(.white)
    .clipShape(RoundedRectangle(cornerRadius: 20))
    .onAppear {
      guard icons.isEmpty else { return }
      Task {
        do {
          icons = try await NetworkClient.shared.request(
            target: FirebaseAPI.icons,
            of: [String].self
          )
        } catch {
          #warning("에러 처리")
        }
      }
    }
  }
}

#Preview("Template") {
  @Previewable @FocusState var isFocused: Bool
  @Previewable @State var isDidTapDownButton: Bool = false
  @Previewable @State var template = Template()
  
  InputTitleAndIconView(
    isFocused: $isFocused,
    isDidTapDownButton: $isDidTapDownButton,
    pocket: $template
  )
}

#Preview("Pocket") {
  @Previewable @FocusState var isFocused: Bool
  @Previewable @State var isDidTapDownButton: Bool = false
  @Previewable @State var pocket = Pocket()
  
  InputTitleAndIconView(
    isFocused: $isFocused,
    isDidTapDownButton: $isDidTapDownButton,
    pocket: $pocket
  )
}
