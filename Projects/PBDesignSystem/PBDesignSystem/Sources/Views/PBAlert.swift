//
//  PBAlert.swift
//  PBDesignSystem
//
//  Created by 이시원 on 3/29/25.
//

import UIKit
import SwiftUI

@MainActor
public enum PBAlertType {
  case delete
  case deleteTemplate
  case deleteAll
  case offAlarm
  case edit
  case hidden
  case error(message: String)
  
  func makeView(isPresented: Binding<Bool>, action: @escaping () -> Void, cancelAction: @escaping () -> Void) -> some View {
    switch self {
    case .delete:
      return PBAlertView(isPresented: isPresented)
        .image(PBImages.pobiAlert.image)
        .title("포켓을 삭제할까요?")
        .body("등록된 소지품이 모두 사라져요!")
        .addButton(.cancel(cancelAction))
        .addButton(.defalt("삭제", action))
    case .deleteTemplate:
      return PBAlertView(isPresented: isPresented)
        .image(PBImages.pobiAlert.image)
        .title("템플릿을 삭제할까요?")
        .body("등록된 소지품이 모두 사라져요!")
        .addButton(.cancel(cancelAction))
        .addButton(.defalt("삭제", action))
    case .deleteAll:
      return PBAlertView(isPresented: isPresented)
        .image(PBImages.pobiAlert.image)
        .title("모든 포켓을 삭제할까요?")
        .body("등록된 소지품과 템플릿이 모두 사라져요!")
        .addButton(.cancel(cancelAction))
        .addButton(.defalt("초기화", action))
    case .offAlarm:
      return PBAlertView(isPresented: isPresented)
        .image(PBImages.warning.image)
        .title("알림 설정이 꺼져있어요")
        .body("휴대폰 설정 > 알림 > 포비에서\n알림을 허용해 주세요!")
        .addButton(.cancel(cancelAction))
        .addButton(.defalt("알림 허용", action))
    case .edit:
      return PBAlertView(isPresented: isPresented)
        .title("포켓을 수정할까요?")
        .body("입력한 내용으로 변경돼요!")
        .addButton(.cancel(cancelAction))
        .addButton(.defalt("수정", action))
    case .hidden:
      return PBAlertView(isPresented: isPresented)
        .title("포켓을 숨길까요?")
        .body("포켓 알림이 비활성화돼요!")
        .addButton(.cancel(cancelAction))
        .addButton(.defalt("숨기기", action))
    case .error(let message):
      return PBAlertView(isPresented: isPresented)
        .image(PBImages.warning.image)
        .title("문제가 발생했어요")
        .body(message)
        .addButton(.defalt("확인", action))
    }
  }
}

public struct PBAlertView: View {
  @Binding private var isPresented: Bool
  @State private var scale: CGFloat = 1.05
  @State private var color = Color.black.opacity(0.0)

  public enum PBAlertButtonType {
    case cancel((() -> Void)? = nil)
    case defalt(String, (() -> Void)? = nil)
  }
  
  private var image: Image?
  private var titie: String = ""
  private var content: String = ""
  private var buttons: [PBAlertButtonType] = []
  
  init(isPresented: Binding<Bool>) {
    self._isPresented = isPresented
  }
  
  public var body: some View {
    color
      .ignoresSafeArea(.all)
      .overlay {
        VStack(spacing: 24) {
          VStack(spacing: 16) {
            image
            VStack(spacing: 8) {
              Text(titie)
                .foregroundStyle(PBColors.navy._900.color)
                .font(PBFonts.title._1.font)
              Text(content)
                .foregroundStyle(PBColors.navy._200.color)
                .font(PBFonts.body._4.font)
                .multilineTextAlignment(.center)
            }
          }
          HStack(spacing: 8) {
            ForEach(buttons.indices, id: \.self) { i in
              switch buttons[i] {
              case let .cancel(action):
                PBRoundButton(8) {
                  isPresented.toggle()
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    action?()
                  }
                } label: {
                  Text("취소")
                    .foregroundStyle(PBColors.navy._500.color)
                    .font(PBFonts.button._2.font)
                }
                .frame(height: 48)
                .foregroundStyle(PBColors.navy._50.color)
              case let .defalt(label, action):
                PBRoundButton(8) {
                  isPresented.toggle()
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    action?()
                  }
                } label: {
                  Text(label)
                    .foregroundStyle(.white)
                    .font(PBFonts.button._2.font)
                }
                .frame(height: 48)
                .foregroundStyle(PBColors.navy._900.color)
              }
            }
          }
        }
        .padding(20)
        .frame(width: 311)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .scaleEffect(scale)
        .onAppear {
          scale = 1
          color = Color.black.opacity(0.2)
        }
      }
      .presentationBackground(.clear)
      .animation(.default, value: scale)
    }
}

extension PBAlertView {
  public func title(_ title: String) -> Self {
    var alert = self
    alert.titie = title
    return alert
  }
  
  public func body(_ body: String) -> Self {
    var alert = self
    alert.content = body
    return alert
  }
  
  public func addButton(_ button: PBAlertButtonType) -> Self {
    var alert = self
    alert.buttons.append(button)
    return alert
  }
  
  public func image(_ image: Image) -> Self {
    var alert = self
    alert.image = image
    return alert
  }
}

public struct PBAlert: ViewModifier {
  @Binding private var isPresented: Bool
  private let alert: PBAlertType
  private let action: () -> Void
  private let cancelAction: () -> Void
  
  public init(isPresented: Binding<Bool>, alert: PBAlertType, action: @escaping () -> Void, cancelAction: @escaping () -> Void) {
    self._isPresented = isPresented
    self.alert = alert
    self.action = action
    self.cancelAction = cancelAction
  }
  
  public func body(content: Content) -> some View {
    content
      .fullScreenCover(isPresented: $isPresented) {
        alert.makeView(isPresented: $isPresented, action: action, cancelAction: cancelAction)
      }
      .transaction { transaction in
        transaction.disablesAnimations = true
      }
  }
}

extension View {
  public func pbAlert(
    isPresented: Binding<Bool>,
    type: PBAlertType,
    okAction: @escaping () -> Void = {},
    cancelAction: @escaping () -> Void = {}
  ) -> some View {
    return modifier(PBAlert(isPresented: isPresented, alert: type, action: okAction, cancelAction: cancelAction))
  }
}

#Preview {
  @Previewable @State var isPresented: Bool = false
  Color.gray
    .overlay {
      Button {
        isPresented = true
      } label: {
        Text("Backgroasdasd\nasdasd\nasdasdund")
      }
    }
    .pbAlert(isPresented: $isPresented, type: .deleteAll, okAction: {})
  
}
