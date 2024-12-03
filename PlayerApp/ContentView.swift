//
//  ContentView.swift
//  PlayerApp
//
//  Created by Israrul on 11/26/24.
//


import SwiftUI
@preconcurrency import WebKit
import AVFoundation

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView {
                // Default YouTube View
                YouTubeWebView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                
                // Download Page
                DownloadPageWebView()
                    .tabItem {
                        Label("Download", systemImage: "arrow.down.circle")
                    }
                
                // Downloaded MP3 List
                DownloadedMP3ListView()
                    .tabItem {
                        Label("Downloads", systemImage: "list.bullet")
                    }
                
                // Player Tab
                MP3PlayerView()
                    .tabItem {
                        Label("Player", systemImage: "play.circle")
                    }
            }
        }
    }
}


//struct DownloadedMP3ListView: View {
//    @State private var downloadedMP3s: [URL] = []
//    @State private var selectedMP3: URL?
//
//    var body: some View {
//        NavigationView {
//            List(downloadedMP3s, id: \..self) { mp3 in
//                Button(mp3.lastPathComponent) {
//                    selectedMP3 = mp3
//                }
//            }
//            .navigationTitle("Downloaded MP3s")
//            .onAppear(perform: loadDownloadedMP3s)
//        }
//        .onChange(of: selectedMP3) { newValue in
//            if let newValue = newValue {
//                NotificationCenter.default.post(name: .playMP3, object: newValue)
//            }
//        }
//    }
//
//    private func loadDownloadedMP3s() {
//        let fileManager = FileManager.default
//        if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
//            do {
//                let files = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
//                downloadedMP3s = files.filter { $0.pathExtension == "mp3" }
//            } catch {
//                print("Error loading files: \(error)")
//            }
//        }
//    }
//}

