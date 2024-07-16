//
//  PurithmTokenResponse.swift
//  Auth
//
//  Created by 이숭인 on 7/12/24.
//

import Foundation

struct PurithmTokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
}
