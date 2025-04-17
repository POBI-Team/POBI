//
//  PBCheckBoxTextField.swift
//  PBDesignSystem
//
//  Created by 이시원 on 2/21/25.
//

import SwiftUI

public struct PBCheckBoxTextFieldModifier: ViewModifier {
  enum CheckBoxState {
    case deactivate
    case unchecked
    case checked
    
    var checkBoxImage: some View {
      switch self {
      case .deactivate: PBImages.deactivateCheckBox.image
      case .unchecked: PBImages.uncheckedCheckBox.image
      case .checked: PBImages.checkedCheckBox.image
      }
    }
  }
  
  @Binding public var title: String
  @Binding public var memo: String
  @Binding public var isChecked: Bool
  @FocusState private var isFocused: Bool
  private var onSubmitAction: () -> Void = {}
  
  public init(
    title: Binding<String>,
    memo: Binding<String>,
    isChecked: Binding<Bool>,
    onSubmitAction: @escaping () -> Void = {}
  ) {
    self._title = title
    self._memo = memo
    self._isChecked = isChecked
    self.onSubmitAction = onSubmitAction
  }
  
  public func body(content: Content) -> some View {
    HStack(alignment: .top) {
      Button {
        withAnimation {
          isChecked.toggle()
        }
        
      } label: {
        checkBox(title: title, isChecked: isChecked).checkBoxImage
      }
      .disabled(checkBox(title: title, isChecked: isChecked) == .deactivate)
      .buttonStyle(PlainButtonStyle())
      
      VStack(spacing: 4) {
       content
          .frame(height: 24)
          .font(PBFonts.body._2.font)
          .foregroundStyle(isChecked ? PBColors.navy._100.color : PBColors.navy._900.color)
          .autocorrectionDisabled(true)
          .focused($isFocused)
          .onChange(of: title) { _, newValue in
            guard newValue.contains("\n") else { return }
            title = newValue.replacing("\n", with: "")
            onSubmitAction()
          }
        if !memo.isEmpty || isFocused || checkBox(title: title, isChecked: isChecked) == .deactivate {
          TextField("메모", text: $memo)
            .focused($isFocused)
            .autocorrectionDisabled(true)
            .font(PBFonts.caption._2.font)
            .foregroundStyle(PBColors.navy._200.color)
        }
      }
    }
    .padding(.vertical, 0)
  }
}

private extension PBCheckBoxTextFieldModifier {
  func checkBox(title: String, isChecked: Bool) -> CheckBoxState {
    if isChecked {
      return .checked
    } else if title.isEmpty || title == "\n" {
      return .deactivate
    } else {
      return .unchecked
    }
  }
}

extension View {
  public func checkBoxAndMemoField(title: Binding<String>, memo: Binding<String>, isChecked: Binding<Bool>, onSubmitAction: @escaping () -> Void) -> some View {
    modifier(PBCheckBoxTextFieldModifier(title: title, memo: memo, isChecked: isChecked, onSubmitAction: onSubmitAction))
  }
}
