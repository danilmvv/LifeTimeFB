import SwiftUI
import AudioToolbox
import AVFoundation

extension ActivityView {
    
    @Observable
    class ViewModel {
        var loadingState = LoadingState.fetched
        var showSavingAlert: Bool = false
        var showActivityAlert: Bool = false
        var showToast: Bool = false
        var toastMessage = ""
        
        var currentSession: Session?
        var isRunning: Bool = false
        var sessionDuration: TimeInterval = 0
        var startTime: Date?
        
        private var timer: Timer?
        private var soundID : SystemSoundID = 1407
        private let feedback = UIImpactFeedbackGenerator(style: .soft)
        
        func startTimer() {
            startTime = Date()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                sessionDuration = Date().timeIntervalSince(startTime!)
            }
            isRunning = true
        }
        
        func stopTimer() {
            timer?.invalidate()
            timer = nil
            isRunning = false
            
            print("\(sessionDuration) секунд")
        }
        
        func reset() {
            isRunning = false
            sessionDuration = 0
            currentSession = nil
        }
        
        func createSession(activity: Activity) {
            let dateFormatter = DateConverter.shared
            
            let newID = UUID().uuidString
            let newSession = Session(
                id: newID,
                activityID: activity.id,
                dateStarted: dateFormatter.getStringFromDate(startTime!),
                startTime: dateFormatter.getTimeString(startTime!),
                endTime: dateFormatter.getTimeString(Date()),
                duration: sessionDuration
            )
            
            currentSession = newSession
        }
        
        func sendFeedback(){
            AudioServicesPlayAlertSoundWithCompletion(soundID, nil)
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate), {})
        }
        
        func showToast(message: String) {
            toastMessage = message
            withAnimation {
                showToast = true
            }
        }
    }
}
