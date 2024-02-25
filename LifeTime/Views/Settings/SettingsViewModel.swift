import Foundation

extension SettingsView {
    
    @Observable
    class ViewModel {
        func signOut() async {
            do {
                try await AuthService.shared.signOut()
            } catch {
                print("Логаут: ОШИБКА")
            }
        }
    }
}
