//
//  KeychainWrapper.swift
//  Auth
//
//  Created by 이숭인 on 7/12/24.
//

import Foundation

//TODO: Xcconfig로 이동시킬 예정
let keychainServiceKey: String = "PurithmServiceKey"
let purithmAccount: String = "com.purithm.app"

public final class KeychainManager {
    public static let shared = KeychainManager()
    private let authKeychainItem = AuthKeychainItem(service: keychainServiceKey, account: purithmAccount)
    
    private init() { }
}

extension KeychainManager: AuthKeychainManageable {
    public func saveAuthToken(accessToken: String) throws {
        let authToken = PurithmAuthToken(
            accessToken: accessToken
        )
        
        try authKeychainItem.save(with: authToken)
    }
    
    public func deleteAuthToken() throws {
        try authKeychainItem.delete()
    }
    
    public func retriveAuthToken() throws -> PurithmAuthToken {
        try authKeychainItem.retrieve()
    }
}
