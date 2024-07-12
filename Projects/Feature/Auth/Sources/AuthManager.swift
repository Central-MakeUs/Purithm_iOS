//
//  AuthManager.swift
//  Auth
//
//  Created by 이숭인 on 7/10/24.
//

import Combine
import CombineExt

//TODO: Authorization 는 Core로 분리하자.

public final class AuthManager {
    public static let shared = AuthManager()
    var cancellables = Set<AnyCancellable>()
    
    private let authRepository: AuthenticationManageable = AuthRepository()
    
    private init() { }
}

extension AuthManager {
    public func isAlreadyLoggedIn() -> Bool {
        //TODO: purithm service token check in local keychain
        return authRepository.isAlreadyLoggedIn()
    }
    
    // apple token
    // name idToken
    public func loginWithKakao() -> AnyPublisher<Void, Error> {
        authRepository.loginWithKakao()
    }
    
    public func loginWithApple() -> AnyPublisher<Void, Error> {
        //TODO: idToken, name 전달해야함!!
        authRepository.loginWithApple(with: "idToken", name: "이름 ~~~")
    }
}
