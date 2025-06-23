//
//  MainTabView.swift
//  Pobi
//
//  Created by 이시원 on 6/13/25.
//

import SwiftUI

import PBDesignSystem
import PBCalendar

struct MainTabView: View {
  @EnvironmentObject var notificationManager: NotificationManager
  
  @Binding var isPresentedCreate: Bool
  
  init(isPresentedCreate: Binding<Bool>) {
    UITabBar.appearance().unselectedItemTintColor = PBColors.navy._50
    UITabBar.appearance().backgroundColor = .white
    self._isPresentedCreate = isPresentedCreate
  }
  
  var body: some View {
    TabView {
      HomeView(isPresentedCreate: $isPresentedCreate)
        .id(notificationManager.seletedPocketID)
        .tabItem {
          PBImages.home.image
        }
      
      ScheduleView()
        .tabItem {
          PBImages.calendar.image
        }
      
      MyPageView()
        .tabItem {
          PBImages.settingFill.image
        }
    }
    .tint(PBColors.navy._900.color)
  }
}

#Preview {
  NavigationStack {
    MainTabView(isPresentedCreate: .constant(false))
      .environmentObject(NotificationManager())
      .environmentObject(PBFormatter())
      .environmentObject(PBCalendarManager())
  }
}
