//
//  OnboardingView.swift
//  Pobi
//
//  Created by 이시원 on 4/1/25.
//

import SwiftUI

import PBDesignSystem

struct OnboardingView: View {
  @State private var currentIndex: Int = 0
  @State private var isPresentedProfileSetting: Bool = false
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Spacer()
        Button {
          isPresentedProfileSetting = true
        } label: {
          Text("SKIP")
            .font(PBFonts.button._1.font)
            .foregroundStyle(PBColors.navy._100.color)
        }
      }
      
      Spacer()
      TabView(selection: $currentIndex) {
        VStack {
          Text("포비와 함께 준비해요!")
            .font(PBFonts.headline._1.font)
            .foregroundStyle(PBColors.navy._900.color)
            .padding(.bottom, 20)
          
          
          Text("포비가 당신의 포켓 비서가 되어\n소지품을 잊지 않도록 도와줄게요!")
            .font(PBFonts.body._1.font)
            .foregroundStyle(PBColors.navy._200.color)
            .padding(.bottom, 69)
            .multilineTextAlignment(.center)
          PBImages.onboardingFirst.image
        }
        .tag(0)
        
        VStack {
          Text("필요한 포켓을 만들어요!")
            .font(PBFonts.headline._1.font)
            .foregroundStyle(PBColors.navy._900.color)
            .padding(.bottom, 20)
          Text("여행, 출근, 운동 등 상황별 포켓을\n만들고 소지품을 추가하세요.")
            .multilineTextAlignment(.center)
            .font(PBFonts.body._1.font)
            .foregroundStyle(PBColors.navy._200.color)
            .padding(.bottom, 35)
          PBImages.onboardingSecond.image
        }
        .tag(1)
        
        VStack {
          Text("똑똑한 알림을 받아요!")
            .font(PBFonts.headline._1.font)
            .foregroundStyle(PBColors.navy._900.color)
            .padding(.bottom, 20)
          Text("포비가 소지품을 챙기도록 알려주고,\n상황별 추천 리스트도 제공해요!")
            .font(PBFonts.body._1.font)
            .multilineTextAlignment(.center)
            .foregroundStyle(PBColors.navy._200.color)
            .padding(.bottom, 35)
          PBImages.onboardingThird.image
        }
        .tag(2)
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      .overlay {
        VStack(spacing: 0) {
          Spacer()
          TabIndicator(count: 3, currentIndex: $currentIndex)
            .padding(.bottom, 62)
        }
      }

      PBRoundButton(16) {
        if currentIndex == 2 {
          isPresentedProfileSetting = true
        } else {
          withAnimation {
            currentIndex += 1
          }
        }
      } label: {
        Text("다음")
          .foregroundStyle(.white)
          .font(PBFonts.button._1.font)
      }
      .frame(height: 52)
      .foregroundStyle(PBColors.navy._900.color)
    }
    .toolbar(.hidden)
    .padding(.horizontal, 20)
    .padding(.bottom, 12)
    .navigationDestination(isPresented: $isPresentedProfileSetting) {
      ProfileSettingView()
    }
  }
}

struct TabIndicator: View {
  private let count: Int
  @Binding private var currentIndex: Int
  
  init(count: Int, currentIndex: Binding<Int>) {
    self.count = count
    self._currentIndex = currentIndex
  }
  
  var body: some View {
    // 가로 방향으로 3개의 세로 막대 배치
    HStack(spacing: 4) {
      ForEach(0..<count, id: \.self) { i in
        Capsule()
          .frame(width: i != currentIndex ? 8 : 20, height: 8)
          .foregroundStyle(i != currentIndex ? PBColors.navy._50.color : PBColors.navy._200.color)
      }
    }
    .animation(.easeInOut(duration: 0.3), value: currentIndex)
  }
}

#Preview {
  OnboardingView()
}
