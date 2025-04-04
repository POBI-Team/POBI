//
//  PBCheckBoxTextField.swift
//  PBDesignSystem
//
//  Created by 이시원 on 2/21/25.
//

import SwiftUI

public struct PBCheckBoxTextField: View {
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
  private var onEditingChanged: (Bool) -> Void
  
  public init(
    title: Binding<String>,
    memo: Binding<String>,
    isChecked: Binding<Bool>,
    onEditingChanged: @escaping (Bool) -> Void  = { _ in }
  ) {
    self._title = title
    self._memo = memo
    self._isChecked = isChecked
    self.onEditingChanged = onEditingChanged
  }
  
  public var body: some View {
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
        TextField("소지품", text: $title)
          .font(PBFonts.body._2.font)
          .foregroundStyle(isChecked ? PBColors.navy._100.color : PBColors.navy._900.color)
          .autocorrectionDisabled(true)
          .focused($isFocused)
        if !memo.isEmpty || isFocused || checkBox(title: title, isChecked: isChecked) == .deactivate {
          TextField("메모", text: $memo)
            .focused($isFocused)
            .autocorrectionDisabled(true)
            .font(PBFonts.caption._2.font)
            .foregroundStyle(PBColors.navy._200.color)
        }
      }
      .onChange(of: isFocused) { _, newValue in
        onEditingChanged(newValue)
      }
    }
  }
}

private extension PBCheckBoxTextField {
  func checkBox(title: String, isChecked: Bool) -> CheckBoxState {
    if isChecked {
      return .checked
    } else if title.isEmpty {
      return .deactivate
    } else {
      return .unchecked
    }
  }
}

#Preview {
  PBCheckBoxTextField(title: .constant(""), memo: .constant(""), isChecked: .constant(false))
  
  PBCheckBoxTextField(title: .constant("aaa"), memo: .constant(""), isChecked: .constant(true))
}
