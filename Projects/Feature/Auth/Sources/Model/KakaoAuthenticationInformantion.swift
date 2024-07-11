//
//  KakaoLoginResponse.swift
//  Auth
//
//  Created by 이숭인 on 7/10/24.
//

import Foundation

// 이 모델을 우리 서버로?
public struct KakaoAuthenticationInformantion {
    let userName: String
    let accessToken: String
    let refreshToken: String
}
