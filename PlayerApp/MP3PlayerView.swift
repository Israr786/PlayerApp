//
//  Untitled.swift
//  PlayerApp
//
//  Created by Israrul on 11/26/24.
//
import SwiftUI
import AVFoundation

struct MP3PlayerView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @State private var currentMP3: URL?
    @State private var isPlaying = false
    @State private var songList: [URL] = []
    @State private var currentIndex: Int = 0

    var body: some View {
        VStack {
            if let currentMP3 = currentMP3 {
                Text("Playing: \(currentMP3.lastPathComponent)")
                    .padding()
            } else {
                Text("No song playing")
                    .padding()
            }

            HStack {
                Button(action: previousTrack) {
                    Image(systemName: "backward.fill")
                        .font(.largeTitle)
                }
                .padding()

                Button(action: togglePlayPause) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.largeTitle)
                }
                .padding()

                Button(action: stopPlayback) {
                    Image(systemName: "stop.fill")
                        .font(.largeTitle)
                }
                .padding()

                Button(action: nextTrack) {
                    Image(systemName: "forward.fill")
                        .font(.largeTitle)
                }
                .padding()
            }
        }
        .onAppear(perform: loadSongList)
        .onReceive(NotificationCenter.default.publisher(for: .playMP3)) { notification in
            if let url = notification.object as? URL {
                playAudio(fileURL: url)
            }
        }
    }

    private func loadSongList() {
        let fileManager = FileManager.default
        if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let files = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                songList = files.filter { $0.pathExtension == "mp3" }
                songList = files.filter { $0.pathExtension == "mp3" }
            } catch {
                print("Error loading files: \(error)")
            }
        }
    }

    private func playAudio(fileURL: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            currentMP3 = fileURL
            isPlaying = true
            currentIndex = songList.firstIndex(of: fileURL) ?? 0
        } catch {
            print("Error playing audio: \(error)")
        }
    }

    private func togglePlayPause() {
        guard let player = audioPlayer else { return }

        if player.isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }

    private func stopPlayback() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        currentMP3 = nil
    }

    private func previousTrack() {
        guard !songList.isEmpty else { return }
        currentIndex = (currentIndex - 1 + songList.count) % songList.count
        playAudio(fileURL: songList[currentIndex])
    }

    private func nextTrack() {
        guard !songList.isEmpty else { return }
        currentIndex = (currentIndex + 1) % songList.count
        playAudio(fileURL: songList[currentIndex])
    }
}

// Notification name for playing MP3
extension Notification.Name {
    static let playMP3 = Notification.Name("playMP3")
}

// Preview for SwiftUI canvas
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
