//
//  DownloadedMP3ListView.swift
//  PlayerApp
//
//  Created by Israrul on 11/26/24.
//

import SwiftUI
import AVFoundation

struct DownloadedMP3ListView: View {
    @State private var downloadedMP3s: [URL] = []
    @State private var selectedMP3: URL?
    @State private var mp3Thumbnails: [URL: UIImage] = [:] // Store thumbnails

    var body: some View {
        NavigationView {
            List(downloadedMP3s, id: \.self) { mp3 in
                HStack {
                    // Thumbnail
                    if let thumbnail = mp3Thumbnails[mp3] {
                        Image(uiImage: thumbnail)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } else {
                        // Placeholder if no thumbnail available
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 40, height: 40)
                    }
                    // Optimized song name display
                    Text(formatSongName(mp3.lastPathComponent))
                        .lineLimit(1) // Restrict to a single line
                        .truncationMode(.tail) // Add ellipsis for overflow
                        .padding(.leading, 10)
                }
                .onTapGesture {
                    selectedMP3 = mp3
                }
            }
            .navigationTitle("Downloaded MP3s")
            .onAppear(perform: loadDownloadedMP3s)
        }
        .onChange(of: selectedMP3) { newValue in
            if let newValue = newValue {
                NotificationCenter.default.post(name: .playMP3, object: newValue)
            }
        }
    }

    private func loadDownloadedMP3s() {
        let fileManager = FileManager.default
        if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let files = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                downloadedMP3s = files.filter { $0.pathExtension == "mp3" }
                // Load thumbnails for each MP3 file
                for mp3 in downloadedMP3s {
                    loadThumbnail(for: mp3)
                }
            } catch {
                print("Error loading files: \(error)")
            }
        }
    }

    private func loadThumbnail(for mp3: URL) {
        // Try to get the thumbnail from the MP3 file metadata using AVAsset
        let asset = AVAsset(url: mp3)
        let generator = AVAssetImageGenerator(asset: asset)
        
        // Try to generate a thumbnail at the first timestamp of the audio
        let time = CMTimeMake(value: 1, timescale: 1)
        generator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { (requestedTime, image, actualTime, result, error) in
            if let image = image, result == .succeeded {
                // Convert CGImage to UIImage and store it
                DispatchQueue.main.async {
                    mp3Thumbnails[mp3] = UIImage(cgImage: image)
                }
            } else {
                // In case thumbnail generation fails, use a placeholder image
                DispatchQueue.main.async {
                    mp3Thumbnails[mp3] = UIImage(systemName: "music.note") // Placeholder icon
                }
            }
        }
    }

    private func formatSongName(_ songName: String) -> String {
        // Truncate song name to make it more readable
        let maxLength = 30 // Adjust as necessary
        if songName.count > maxLength {
            let index = songName.index(songName.startIndex, offsetBy: maxLength)
            return String(songName[..<index]) + "..."
        } else {
            return songName
        }
    }
}


