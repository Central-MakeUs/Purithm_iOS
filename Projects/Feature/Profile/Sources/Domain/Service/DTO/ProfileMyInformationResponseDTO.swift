//
//  ProfileMyInformationResponseDTO.swift
//  Profile
//
//  Created by 이숭인 on 8/21/24.
//

import Foundation

public struct ProfileMyInformationResponseDTO: Codable {
    let userID: Int
    let userName: String
    let profileThumbnailString: String
    let stampCount: Int
    let likeCount: Int
    let filterViewHistoryCount: Int
    let reviewCount: Int
    
    enum CodingKeys: String, CodingKey {
        case userID = "id"
        case userName = "name"
        case profileThumbnailString = "profile"
        case stampCount = "stamp"
        case likeCount = "likes"
        case filterViewHistoryCount = "filterViewCount"
        case reviewCount = "reviews"
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(Int.self, forKey: .userID)
        self.userName = try container.decodeIfPresent(String.self, forKey: .userName) ?? ""
        self.profileThumbnailString = try container.decodeIfPresent(String.self, forKey: .profileThumbnailString) ?? ""
        self.stampCount = try container.decode(Int.self, forKey: .stampCount)
        self.likeCount = try container.decode(Int.self, forKey: .likeCount)
        self.filterViewHistoryCount = try container.decode(Int.self, forKey: .filterViewHistoryCount)
        self.reviewCount = try container.decode(Int.self, forKey: .reviewCount)
    }
}
