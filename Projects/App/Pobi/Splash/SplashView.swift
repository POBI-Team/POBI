//
//  SplashView.swift
//  Pobi
//
//  Created by 이시원 on 4/1/25.
//

import SwiftUI
import Combine

import PBDesignSystem
import PBStorage
import LocalNotiService

import Lottie

struct SplashView: View {
  @State private var isEndSplash: Bool = false
  @State private var isNotFirstEntry: Bool
  @State private var isPresnetedCreate: Bool = false
  @State private var cancelBag: Set<AnyCancellable> = []
  
  init() {
    self.isNotFirstEntry = ProfileStorage.shared.loadNotFirstEntry()
  }
  
  var body: some View {
    if !isEndSplash {
      PBColors.cream.color
        .ignoresSafeArea(.all)
        .overlay {
          VStack(spacing: 0) {
            Text("나의 포켓비서")
              .font(PBFonts.title._1.font)
              .foregroundStyle(PBColors.navy._200.color)
            PBImages.logo.image
              .padding(.bottom, 100)
            LottieView(animation: .named("pobi_splash"))
              .playing()
              .animationDidFinish { _ in
                withAnimation {
                  isEndSplash = true
                }
              }
          }
        }
    } else {
      if isNotFirstEntry {
         NavigationStack {
           HomeView(isPresentedCreate: $isPresnetedCreate)
             .modelContainer(try! PocketStorage().modelContainer)
        }
         .transition(.move(edge: .trailing))
      } else {
        NavigationStack {
          OnboardingView()
            .onAppear {
              NotificationCenter.default.publisher(for: .skip)
                .sink { _ in
                  withAnimation {
                    isNotFirstEntry = true
                  }
                }
                .store(in: &cancelBag)
              
              NotificationCenter.default.publisher(for: .createPocket)
                .sink { _ in
                  withAnimation {
                    isNotFirstEntry = true
                    isPresnetedCreate = true
                  }
                }
                .store(in: &cancelBag)
            }
        }
        .transition(.move(edge: .trailing))
      }
    }
  }
}

#Preview {
  SplashView()
}
