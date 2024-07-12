//
//  AppleLoginRequest.swift
//  Auth
//
//  Created by 이숭인 on 7/12/24.
//

import Foundation

struct AppleLoginRequest: Encodable {
    let userName: String
    let idToken: String
}
