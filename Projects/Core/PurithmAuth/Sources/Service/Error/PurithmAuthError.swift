//
//  PurithmAuthError.swift
//  CorePurithmAuth
//
//  Created by 이숭인 on 8/2/24.
//

import Foundation

public enum PurithmAuthError: Error {
    case termsOfServiceRequired
    case invalidToken
    case resourceNotFound
    case invalidErrorType
    
    var localizedDescription: String {
        switch self {
        case .termsOfServiceRequired:
            return "이용약관 동의가 필요합니다."
        case .invalidToken:
            return "유효하지 않은 토큰입니다."
        case .resourceNotFound:
            return "리소스를 찾을 수 없습니다."
        case .invalidErrorType:
            return "잘못된 서버 응답 코드입니다."
        }
    }
}
