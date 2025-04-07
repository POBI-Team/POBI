//
//  PBToast.swift
//  PBDesignSystem
//
//  Created by 이시원 on 4/7/25.
//

import SwiftUI

public struct PBToastView: View {
  private let message: String
  
  public init(message: String) {
    self.message = message
  }
  
  public var body: some View {
    HStack(spacing: 8) {
      PBImages.warningCycle.image
      Text(message)
        .font(PBFonts.body._3.font)
        .foregroundStyle(PBColors.navy._900.color)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background {
      TransparentBlurView(
        blur: 3,
        color: PBColors.red.withAlphaComponent(0.2).color
      )
    }
    .clipShape(Capsule())
  }
}


private struct TransparentBlurView: View {
  var blur: CGFloat
  var color: Color
  
  var body: some View {
    TransparentBlur()
      .blur(radius: blur, opaque: true)
      .overlay {
        color
      }
  }
}

private struct TransparentBlur: UIViewRepresentable {
  func makeUIView(context: Context) -> UIVisualEffectView {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    return view
  }
  
  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    DispatchQueue.main.async {
      if let backdropLayer = uiView.layer.sublayers?.first {
        backdropLayer.filters = []
      }
    }
  }
}

public struct PBToast: ViewModifier {
  @Binding private var toastID: UUID?
  private let message: String
  private let height: CGFloat
  @State private var dismissTask: DispatchWorkItem?
  public init(toastID: Binding<UUID?>, message: String, height: CGFloat) {
    self._toastID = toastID
    self.message = message
    self.height = height
  }
  
  public func body(content: Content) -> some View {
    
    content
      .overlay(alignment: .center) {
        if toastID != nil {
          VStack {
            Spacer()
            PBToastView(
              message: message
            )
            Spacer()
              .frame(height: height)
          }
          
        }
      }
      .onChange(of: toastID) { _, new in
        if new != nil {
          dismissTask?.cancel()
          dismissTask = DispatchWorkItem {
            toastID = nil
          }
          DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: dismissTask!)
        }
      }
      .animation(.default, value: toastID)
  }
}

extension View {
  public func pbToast(toastID: Binding<UUID?>, message: String, height: CGFloat = 0) -> some View {
    return modifier(PBToast(toastID: toastID, message: message, height: height))
  }
}

#Preview {
  @Previewable @State var toastID: UUID? = nil
  Color.gray
    .overlay {
      Button {
        toastID = .init()
      } label: {
        Text("Backgroasdasd\nasdasd\nasdasdund")
      }
    }
    .pbToast(toastID: $toastID, message: "Hello, World!")
  
}
