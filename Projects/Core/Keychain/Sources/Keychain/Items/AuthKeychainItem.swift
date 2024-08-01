//
//  AuthKeychainItem.swift
//  Auth
//
//  Created by 이숭인 on 7/12/24.
//

import Foundation

public struct AuthKeychainItem: KeychainService {
    public typealias KeychainData = PurithmAuthToken
    
    public let service: String
    public let account: String
    
    init(service: String, account: String) {
        self.service = service
        self.account = account
    }
}

public struct PurithmAuthToken: Codable {
    public let accessToken: String
}
