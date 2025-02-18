//
//  ColorCell.swift
//  PBDesignSystemDemo
//
//  Created by 이시원 on 2/18/25.
//

import SwiftUI

struct ColorCell: View {
  let color: Color
  let text: Text
  
  var body: some View {
    HStack {
      Spacer()
      text
      Spacer()
    }
    .frame(height: 50)
    .background(color)
  }
}

#Preview {
  ColorCell(color: .red, text: Text("블루"))
}
