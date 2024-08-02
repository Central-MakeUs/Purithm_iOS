//
//  AppleSignInRequestDTO.swift
//  CorePurithmAuth
//
//  Created by 이숭인 on 8/1/24.
//

import Foundation

struct AppleSignInRequestDTO {
    let userName: String
    
    func toDictionary() -> [String: Any] {
        return [
            "username": userName
        ]
    }
}
