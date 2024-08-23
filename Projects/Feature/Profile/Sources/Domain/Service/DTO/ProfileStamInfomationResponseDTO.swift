//
//  ProfileStamInfomationResponseDTO.swift
//  Profile
//
//  Created by 이숭인 on 8/21/24.
//

import Foundation
import CoreUIKit

public struct ProfileStamInfomationResponseDTO: Codable {
    let totalCount: Int
    let list: [StampHistory]
}

extension ProfileStamInfomationResponseDTO {
    struct StampHistory: Codable {
        let date: String
        let stamps: [Stamp]
    }

    struct Stamp: Codable {
        let filterId: Int
        let filterName: String
        let photographer: String
        let thumbnail: String
        let createdAt: String
        let membership: String
        let reviewId: Int
    }
}
