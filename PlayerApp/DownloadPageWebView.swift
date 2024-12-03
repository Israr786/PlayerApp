//
//  Untitled.swift
//  PlayerApp
//
//  Created by Israrul on 11/26/24.
//

import SwiftUI
@preconcurrency import WebKit

struct DownloadPageWebView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        let url = URL(string: "https://ytmp3.cc/en-GDZy/")!
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No updates needed for now
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: DownloadPageWebView

        init(_ parent: DownloadPageWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("didStartProvisionalNavigation: \(String(describing: navigation))")
        }

        func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
            print("didReceiveServerRedirectForProvisionalNavigation: \(String(describing: navigation))")
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("didFailProvisionalNavigation: \(String(describing: navigation)), error: \(error)")
        }

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            print("didCommitNavigation: \(String(describing: navigation))")
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("didFinishLoadingNavigation: \(String(describing: navigation))")
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("didFailNavigation: \(String(describing: navigation)), error \(error)")

            if let failingURL = (error as NSError).userInfo[NSURLErrorFailingURLStringErrorKey] as? String,
               let url = URL(string: failingURL) {
                print("Failed URL: \(failingURL)")

                let downloadTask = URLSession.shared.downloadTask(with: url) { location, response, error in
                    guard let location = location, error == nil else {
                        print("Download error: \(String(describing: error))")
                        return
                    }

                    if let httpResponse = response as? HTTPURLResponse,
                       let contentDisposition = httpResponse.allHeaderFields["Content-Disposition"] as? String {
                        let fileName = contentDisposition.replacingOccurrences(of: "attachment; filename=\"", with: "")
                                                              .replacingOccurrences(of: "\"", with: "")

                        let fileManager = FileManager.default
                        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let destinationURL = documentsURL.appendingPathComponent(fileName)

                        do {
                            try fileManager.moveItem(at: location, to: destinationURL)
                            print("File saved to: \(destinationURL.path)")
                        } catch {
                            print("File save error: \(error)")
                        }
                    }
                }

                downloadTask.resume()
            }
        }

        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            print("WebContent process crashed; reloading")
            webView.reload()
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            print("decidePolicyForNavigationResponse")
            decisionHandler(.allow)
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            print("decidePolicyForNavigationAction")
            decisionHandler(.allow)
        }
    }
}
