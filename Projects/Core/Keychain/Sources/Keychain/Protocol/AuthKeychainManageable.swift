//
//  AuthKeychainManageable.swift
//  Auth
//
//  Created by 이숭인 on 7/12/24.
//

import Foundation

public protocol AuthKeychainManageable {
    func saveAuthToken(accessToken: String, refreshToken: String) throws
    func deleteAuthToken() throws
    func retriveAuthToken() throws -> PurithmAuthToken?
}
