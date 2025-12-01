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
    let appearance = UITabBarAppearance()
    appearance.backgroundColor = .white
    appearance.shadowColor = PBColors.navy._50
    appearance.stackedLayoutAppearance.normal.iconColor = PBColors.navy._50
    UITabBar.appearance().scrollEdgeAppearance = appearance
    UITabBar.appearance().standardAppearance = appearance
    self._isPresentedCreate = isPresentedCreate
    changeIcon()
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
  
  private func changeIcon() {
    let currentAppIconName: String? = UIApplication.shared.alternateIconName
    
    var newAppIcon: String? = nil
    if let appIconName = getIconNameByEvent(start: (12, 1), end: (12, 25)) { /// 크리스마스 시즌
      newAppIcon = appIconName
    }
    
    if currentAppIconName != newAppIcon {
      UIApplication.shared.setAlternateIconName(newAppIcon)
    }
  }
  
  func getIconNameByEvent(
    start: (month: Int, day: Int),
    end: (month: Int, day: Int)
  ) -> String? {
    let calendar = Calendar.current
    let now = Date()
    let year = calendar.component(.year, from: now)
    
    // 12월 1일 00:00
    guard let start = calendar.date(from: DateComponents(year: year, month: start.month, day: start.day)),
          let end = calendar.date(from: DateComponents(year: year, month: end.month, day: end.day + 1)) else { return nil }
    
    return now >= start && now < end ? "WinterAppIcon" : nil
  }
}

#if DEBUG
import PBStorage

#Preview {
  NavigationStack {
    MainTabView(isPresentedCreate: .constant(false))
      .environmentObject(NotificationManager())
      .environmentObject(PBFormatter())
      .environmentObject(PBCalendarManager())
      .environmentObject(ProfileStorage())
  }
}
#endif
