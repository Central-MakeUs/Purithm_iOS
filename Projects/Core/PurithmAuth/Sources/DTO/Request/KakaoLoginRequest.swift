//
//  KakaoLoginRequest.swift
//  Auth
//
//  Created by 이숭인 on 7/12/24.
//

import Foundation

struct KakaoLoginRequest: Encodable {
    let userName: String
    let accessToken: String
    let refreshToken: String
}
