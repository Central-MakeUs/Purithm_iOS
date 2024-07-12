//
//  AuthError.swift
//  Auth
//
//  Created by 이숭인 on 7/10/24.
//

import Foundation

public enum AuthError: Error {
    case KakaoTalkLoginFailed
    case KakaoAccountLoginFailed
    
    case referenceInvalidError
}
