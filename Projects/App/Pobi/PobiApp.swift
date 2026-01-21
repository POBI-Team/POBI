//
//  PobiApp.swift
//  Pobi
//
//  Created by 이시원 on 2/15/25.
//

import UIKit
import SwiftUI
import CoreData
import CloudKit

import PBDesignSystem
import PBStorage
import PBStorageInterface
import PBCalendar

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
  open override func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}

class NotificationManager: ObservableObject {
  @Published var seletedPocketID: UUID?
  
  func handleNotificationTap(id: UUID?) {
    seletedPocketID = id
  }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  var notificationManager = NotificationManager()
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    UNUserNotificationCenter.current().delegate = self
    FirebaseManager.shared.initSDK()
    IntArrayValueTransformer.register()
    return true
  }
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
    sceneConfig.delegateClass = SceneDelegate.self
    return sceneConfig
  }
  
//  앱이 포그라운드에 있을 때 알림 표시
//  func userNotificationCenter(_ center: UNUserNotificationCenter,
//                              willPresent notification: UNNotification,
//                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//    completionHandler([.banner, .sound])
//  }
  
  nonisolated func userNotificationCenter(_ center: UNUserNotificationCenter,
                                          didReceive response: UNNotificationResponse,
                                          withCompletionHandler completionHandler: @escaping () -> Void) {
    defer {
      completionHandler()
    }
    guard let id = response.notification.request.content.userInfo["id"] as? String else { return }
    DispatchQueue.main.async {
      self.notificationManager.handleNotificationTap(id: UUID(uuidString: id))
    }
  }
}

final class SceneDelegate: NSObject, UIWindowSceneDelegate {
  func windowScene(_ windowScene: UIWindowScene, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {}
}

@main
struct PobiApp: App {
  @StateObject var notificationManager = NotificationManager()
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  init() {
    PBFonts.registerFont()
  }
  
  var body: some Scene {
    WindowGroup {
      SplashView()
        .environment(\.managedObjectContext, PocketStorage.shared.context)
        .environmentObject(PocketStorage.shared)
        .environmentObject(appDelegate.notificationManager)
        .environmentObject(PBFormatter())
        .environmentObject(PBCalendarManager())
        .environmentObject(ProfileStorage())
    }
  }
}
