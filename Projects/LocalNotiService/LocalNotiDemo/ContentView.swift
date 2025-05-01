//
//  ContentView.swift
//  LocalNotiDemo
//
//  Created by 이시원 on 3/23/25.
//

import SwiftUI

import LocalNotiService

struct ContentView: View {
  @State var seletecDate: Date = Date()
  @State var hour = ""
  @State var minute = ""
  var body: some View {
    Group {
      TextField("시간 입력", text: $hour)
      TextField("분 입력", text: $minute)
    }
    .keyboardType(.numberPad)
    
    Button {
      LocalNotiCenter.shared.register(
        title: "푸쉬 알림 테스트",
        body: "해당 메시지는 테스트를 위한 메시지입니다",
        id: "1111-1111",
        trigerType: .day(days: [24]),
        hour: UInt(hour)!,
        minute: UInt(minute)!
      )
    } label: {
      Text("푸쉬 알림 등록")
    }
    Button {
      LocalNotiCenter.shared.removeAlert(id: "1111-1111", type: .day(days: [24]))
    } label: {
      Text("얼럿 지우기")
    }
    Button {
      LocalNotiCenter.shared.removeAll()
      print("알림 삭제")
    } label: {
      Text("푸쉬 알림 삭제")
    }

  }
}

#Preview {
  ContentView()
}
