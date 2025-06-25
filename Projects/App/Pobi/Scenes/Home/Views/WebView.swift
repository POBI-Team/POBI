//
//  WebView.swift
//  Pobi
//
//  Created by 이시원 on 6/25/25.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
  private var url: String
  
  init(url: String) {
    self.url = url
  }
  
  func makeUIView(context: Context) -> WKWebView {
    guard let url = URL(string: url) else {
      return WKWebView()
    }
    let webView = WKWebView()
    
    webView.load(URLRequest(url: url))
    
    return webView
  }
  
  func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<WebView>) {
    guard let url = URL(string: url) else { return }
    
    webView.load(URLRequest(url: url))
  }
}

#Preview {
  WebView(url: "https://furry-gruyere-f25.notion.site/1-1-0-21c0c2771f6d80f0a7f5eb638ab0f16d?source=copy_link")
}
