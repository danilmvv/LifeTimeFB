import Foundation

extension AuthView {
    
    @Observable
    class ViewModel {
        func anonSignIn() async {
            do {
                try await AuthService.shared.anonymousSignIn()
            } catch {
                print("Анонимный логин: ОШИБКА")
            }
        }
    }
}
