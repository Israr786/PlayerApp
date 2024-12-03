//
//  YouTubeWebView.swift
//  PlayerApp
//
//  Created by Israrul on 11/26/24.
//

import SwiftUI
@preconcurrency import WebKit

//struct YouTubeWebView: UIViewRepresentable {
//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        let url = URL(string: "https://www.youtube.com")!
//        let request = URLRequest(url: url)
//        webView.load(request)
//        return webView
//    }
//
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        // No updates needed for now
//    }
//}

struct YouTubeWebView: UIViewRepresentable {
    // This method will create and return a Coordinator instance
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: YouTubeWebView
        
        init(parent: YouTubeWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Optionally handle after the page finishes loading
        }
    }

    @State private var webView: WKWebView?

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        self.webView = webView
        let url = URL(string: "https://www.youtube.com")!
        let request = URLRequest(url: url)
        webView.load(request)
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No updates needed for now
    }

    // Function to reload the web view
    func reloadWebView() {
        webView?.reload()
    }

    var body: some View {
        NavigationView {
            // Here we just display the WKWebView from makeUIView
            YouTubeWebView()
                .navigationBarTitle("YouTube", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    reloadWebView() // Reload action
                }) {
                    Image(systemName: "arrow.clockwise.circle.fill") // Reload icon
                        .font(.title)
                        .padding()
                })
        }
        .navigationTitle("Tetsing")
    }
}
