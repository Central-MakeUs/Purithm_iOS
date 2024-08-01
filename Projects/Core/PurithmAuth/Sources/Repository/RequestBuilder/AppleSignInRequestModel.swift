//
//  AppleSignInRequestModel.swift
//  CorePurithmAuth
//
//  Created by 이숭인 on 8/1/24.
//

import Foundation

struct AppleSignInRequestModel: Encodable {
    let userName: String
    
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
    }
}
