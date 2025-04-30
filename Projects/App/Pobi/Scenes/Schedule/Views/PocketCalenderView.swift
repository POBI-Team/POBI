//
//  PocketCalenderView.swift
//  Pobi
//
//  Created by 이시원 on 4/30/25.
//

import SwiftUI

struct PocketCalenderView: View {
    var body: some View {
      VStack(spacing: 0) {
        HStack {
          ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { weekday in
            Text(weekday)
              .frame(maxWidth: .infinity)
          }
        }
        .frame(height: 31)
        .padding(.horizontal, 4)
        GeometryReader { geometry in
          LazyVGrid(
            columns: Array(repeating: GridItem(spacing: 0), count: 7),
            spacing: 0
          ) {
            ForEach(0..<42, id: \.self) { i in
              VStack {
                Text("\(i)")
                Spacer()
              }
              .padding(.horizontal, 4)
              .padding(.vertical, 8)
              .frame(maxWidth: .infinity)
              .frame(height: geometry.size.height / (42 / 7))
            }
          }
        }
      }
    }
}

#Preview {
    PocketCalenderView()
}
