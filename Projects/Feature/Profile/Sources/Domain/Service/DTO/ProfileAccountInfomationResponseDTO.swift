//
//  ProfileAccountInfomationResponseDTO.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import Foundation

public struct ProfileAccountInfomationResponseDTO: Codable {
    let provider: String // KAKAO, APPLE
    let createdAt: String
    let email: String
}

