//
//  PBCheckBoxTextField.swift
//  PBDesignSystem
//
//  Created by 이시원 on 2/21/25.
//

import SwiftUI

public struct PBCheckBoxTextField: View {
  private enum CheckBoxState {
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
  
  @State private var checkBoxState: CheckBoxState = .deactivate
  @Binding public var title: String
  @Binding public var memo: String
  
  public init(title: Binding<String>, memo: Binding<String>) {
    self._title = title
    self._memo = memo
  }
  
  public var body: some View {
    HStack(alignment: .top) {
      Button {
        checkBoxState = checkBoxState == .unchecked ? .checked : .unchecked
      } label: {
        checkBoxState.checkBoxImage
      }
      .disabled(checkBoxState == .deactivate)
      .buttonStyle(PlainButtonStyle())
      
      VStack(spacing: 2) {
        TextField("소지품  입력", text: $title) {
          if !$0 {
            checkBoxState = title.isEmpty ? .deactivate : .unchecked
          }
        }
        .font(PBFonts.body._2.font)
        .foregroundStyle(PBColors.navy._900.color)
        TextField("메모", text: $memo)
          .font(PBFonts.caption._2.font)
          .foregroundStyle(PBColors.navy._200.color)
      }
      .onChange(of: title) { oldValue, newValue in
      }
    }
  }
}

#Preview {
  PBCheckBoxTextField(title: .constant(""), memo: .constant(""))
}
