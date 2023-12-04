//
//  TapView.swift
//  TapMe
//
//  Created by Bojan Mijic on 4.12.23..
//



import SwiftUI
import CoreHaptics
import AVFoundation
import AudioToolbox
import UIKit

class TapCounter: ObservableObject {
    @Published var count: Int = UserDefaults.standard.integer(forKey: "totalTaps")

    func saveTotalTaps() {
        UserDefaults.standard.set(count, forKey: "totalTaps")
    }
}

class TapViewModel: ObservableObject {
    @Published var tapCount: Int = UserDefaults.standard.integer(forKey: "totalTaps")

    func incrementTapCount() {
        tapCount += 1
        UserDefaults.standard.set(tapCount, forKey: "totalTaps")
    }

    func resetTapCount() {
        tapCount = 0
        UserDefaults.standard.set(tapCount, forKey: "totalTaps")
    }
}

class HapticManager: ObservableObject {
    private var hapticEngine: CHHapticEngine?

    init() {
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Error starting haptic engine: \(error.localizedDescription)")
        }

        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc func appDidEnterBackground() {
        hapticEngine?.stop()
    }

    @objc func appWillEnterForeground() {
        do {
            try hapticEngine?.start()
        } catch {
            print("Error restarting haptic engine: \(error.localizedDescription)")
        }
    }

    func generateHapticFeedback() {
        guard let hapticEngine = hapticEngine else {
            print("Haptic engine not initialized.")
            return
        }

        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0)

        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try hapticEngine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Error generating haptic feedback: \(error.localizedDescription)")
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        hapticEngine?.stop()
        hapticEngine = nil
    }
}

struct TapView: View {
    @ObservedObject private var tapCounter = TapCounter()
    @ObservedObject private var hapticManager = HapticManager()
    @StateObject private var tapViewModel: TapViewModel
    @State private var isSoundOn = true
    @State private var isHapticsOn = true
    
    init(tapViewModel: TapViewModel) {
        _tapViewModel = StateObject(wrappedValue: tapViewModel)
    }
    
    var body: some View {
        VStack {
            Text("Your tap count")
                .font(.title)
                .foregroundColor(.primary)
            
            Text("\(tapCounter.count)")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Button(action: {
                tapViewModel.incrementTapCount()
                tapCounter.count += 1
                generateFeedback()
            }) {
                HStack {
                    Image(systemName: "hand.tap")
                        .foregroundColor(.white)
                        .imageScale(.large)
                        .padding(.trailing, 10)
                    
                    Text("Tap me!")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .frame(width: 200, height: 60)
                .background(Color.black)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 1.5)
                )
            }
        }
        .padding()
        .onChange(of: tapCounter.count) { _ in
            tapCounter.saveTotalTaps()
        }
    }
    
    private func generateFeedback() {
        if isSoundOn {
            AudioServicesPlaySystemSound(1104) // or use kSystemSoundID_Click
        }

        if isHapticsOn {
            hapticManager.generateHapticFeedback()
        }
    }

    struct TapView_Previews: PreviewProvider {
        static var previews: some View {
            TapView(tapViewModel: TapViewModel())
        }
    }
}
