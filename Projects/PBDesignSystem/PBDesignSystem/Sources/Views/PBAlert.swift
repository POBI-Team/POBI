//
//  PBAlert.swift
//  PBDesignSystem
//
//  Created by 이시원 on 3/29/25.
//

import SwiftUI

@MainActor
public struct PBAlert {
  public static func delete(_ action: @escaping () -> Void) -> PBAlertView {
    return PBAlertView()
      .image(PBImages.pobiAlert.image)
      .title("포켓을 삭제할까요?")
      .body("등록된 소지품이 모두 사라져요!")
      .addButton(.cancel())
      .addButton(.defalt("삭제", action))
  }
  
  public static func edit(_ action: @escaping () -> Void) -> PBAlertView {
    return PBAlertView()
      .title("포켓을 수정할까요?")
      .body("입력한 내용으로 변경돼요!")
      .addButton(.cancel())
      .addButton(.defalt("수정", action))
  }
  
  public static func hidden(_ action: @escaping () -> Void) -> PBAlertView {
    return PBAlertView()
      .title("포켓을 숨길까요?")
      .body("포켓 알림이 비활성화돼요!")
      .addButton(.cancel())
      .addButton(.defalt("숨기기", action))
  }
}

public struct PBAlertView: View {
  public enum PBAlertButtonType {
    case cancel((() -> Void)? = nil)
    case defalt(String, (() -> Void)? = nil)
  }
  
  private var image: Image?
  private var titie: String = ""
  private var content: String = ""
  private var buttons: [PBAlertButtonType] = []
  
  public var body: some View {
    Color.black.opacity(0.2)
      .ignoresSafeArea(.all)
      .overlay {
        VStack(spacing: 24) {
          VStack(spacing: 20) {
            image
            VStack(spacing: 4) {
              Text(titie)
                .foregroundStyle(PBColors.navy._900.color)
                .font(PBFonts.title._1.font)
              Text(content)
                .foregroundStyle(PBColors.navy._200.color)
                .font(PBFonts.body._4.font)
            }
          }
          HStack(spacing: 8) {
            ForEach(buttons.indices, id: \.self) { i in
              switch buttons[i] {
              case let .cancel(action):
                PBRoundButton(8) {
                  action?()
                } label: {
                  Text("취소")
                    .foregroundStyle(PBColors.navy._500.color)
                    .font(PBFonts.title._1.font)
                }
                .frame(height: 48)
                .foregroundStyle(PBColors.navy._50.color)
              case let .defalt(label, action):
                PBRoundButton(8) {
                  action?()
                } label: {
                  Text(label)
                    .foregroundStyle(.white)
                    .font(PBFonts.title._1.font)
                }
                .frame(height: 48)
                .foregroundStyle(PBColors.navy._900.color)
              }
            }
          }
        }
        .padding(20)
        .frame(width: 335)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
      }
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

#Preview("delete") {
  PBAlert.delete {}
}

#Preview("edit") {
  PBAlert.edit {}
}

#Preview("hidden") {
  PBAlert.hidden {}
}
