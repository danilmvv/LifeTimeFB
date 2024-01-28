import Foundation
import AuthenticationServices
import FirebaseAuth
import CryptoKit

enum AuthState {
    case authenticated // Анон
    case signedIn
    case signedOut
}

@MainActor
@Observable
class AuthService {
    var user: User?
    var authState = AuthState.signedOut
    
    private var currentNonce: String?
    
    static let shared = AuthService()
    
    init() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            print("Auth changed: \(user != nil)")
            self.updateState(user: user)
        }
    }
    
    func signUp(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func anonymousSignIn() async throws {
        try await Auth.auth().signInAnonymously()
    }
    
    func linkEmail(email: String, password: String) async throws -> AuthDataResult? {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        guard let user = self.user else {
            throw URLError(.badURL)
        }
        
        let result = try await user.link(with: credential)
        updateState(user: result.user)
        
        return result
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func updateState(user: User?) {
        self.user = user
        let isAuthenticatedUser = user != nil
        let isAnonymous = user?.isAnonymous ?? false
        
        if isAuthenticatedUser {
            self.authState = isAnonymous ? .authenticated : .signedIn
        } else {
            self.authState = .signedOut
        }
    }
    
    var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
}

// Apple
extension AuthService {
    func appleSignIn(tokens: String) async throws {
        ///
    }
    
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        //        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        //        authorizationController.delegate = self
        //        authorizationController.presentationContextProvider = self
        //        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
