import Foundation

extension EmailSignInView {
    
    @Observable
    class ViewModel {
        var email = ""
        var password = ""
        var errorMessage = ""
        var showAuthView = true
        
        func signIn() async {
            errorMessage = ""
            
            guard validate() else {
                print("Failed validation")
                return
            }
            
            do {
                try await AuthService.shared.signIn(email: email, password: password)
                return
            } catch {
                print("Аккаунт не найден")
            }
            
            do {
                try await AuthService.shared.signUp(email: email, password: password)
                return
            } catch {
                errorMessage = error.localizedDescription
            }
        }
        
        func linkEmail() async {
            errorMessage = ""
            
            guard validate() else {
                print("Failed validation")
                return
            }
            
            print(email, password)
            
            do {
                let _ = try await AuthService.shared.linkEmail(email: email, password: password)
                return
            } catch {
                errorMessage = error.localizedDescription
            }
        }
        
        private func validate() -> Bool {
            errorMessage = ""
            
            guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
                  !password.trimmingCharacters(in: .whitespaces).isEmpty else {
                errorMessage = "Заполните все поля"
                return false
            }
            
            guard Validator.validateEmail(email) else {
                errorMessage = "Неверный email"
                return false
            }
            
            guard Validator.validatePassword(password) else {
                errorMessage = "Неверный пароль"
                return false
            }
            
            return true
        }
    }
}
