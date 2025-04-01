//
//  SplashView.swift
//  Pobi
//
//  Created by 이시원 on 4/1/25.
//

import SwiftUI

import PBDesignSystem
import PBStorage
import LocalNotiService

import Lottie

struct SplashView: View {
  @State private var isPresentedOnboarding: Bool = false
  
  var body: some View {
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
              isPresentedOnboarding = true
            }
        }
      }
      .navigationDestination(isPresented: $isPresentedOnboarding) {
        OnboardingView()
      }
  }
}

#Preview {
  SplashView()
}
