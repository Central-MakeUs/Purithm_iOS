//
//  AuthRepository.swift
//  Auth
//
//  Created by 이숭인 on 7/10/24.
//

import Combine
import RxSwift
import CoreKeychain

public final class AuthRepository {
    let disposeBag = DisposeBag()
    var cancellables = Set<AnyCancellable>()
    
    public init() { }
    
    public func saveAuthToken(accessToken: String) throws {
        try KeychainManager.shared.saveAuthToken(
            accessToken: accessToken
        )
    }
    
    public func retriveAuthToken() throws -> PurithmAuthToken {
        try KeychainManager.shared.retriveAuthToken()
    }
    
    public func deleteAuthToken() throws {
        try KeychainManager.shared.deleteAuthToken()
    }
}
