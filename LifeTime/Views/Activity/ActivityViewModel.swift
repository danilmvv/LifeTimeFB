import SwiftUI
import AudioToolbox
import AVFoundation

extension ActivityView {
    
    @Observable
    class ViewModel {
        var loadingState = LoadingState.fetched
        
        var isRunning: Bool = false
        var elapsedTime: TimeInterval = 0
        var sessionDuration: TimeInterval = 0
        var startTime: Date?
        
        private var timer: Timer?
        private var soundID : SystemSoundID = 1407
        private let feedback = UIImpactFeedbackGenerator(style: .soft)
        
        
        func toggleTimer() {
            if isRunning {
                stopTimer()
            } else {
                startTimer()
            }
        }
        
        func startTimer() {
            startTime = Date()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                elapsedTime = Date().timeIntervalSince(startTime!)
            }
            isRunning = true
        }
        
        func stopTimer() {
            timer?.invalidate()
            timer = nil
            if let startTime = startTime {
                sessionDuration += Date().timeIntervalSince(startTime)
            }
            isRunning = false
            reset()
        }
        
        func reset() {
            isRunning = false
            elapsedTime = 0
        }
        
        private func sendFeedback(){
            AudioServicesPlayAlertSoundWithCompletion(soundID, nil)
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate), {})
        }
    }
}
