//
//  ReviewLoadResponseDTO.swift
//  Review
//
//  Created by 이숭인 on 8/19/24.
//

import Foundation
import CoreUIKit
import CoreCommonKit

public struct ReviewLoadResponseDTO: Codable {
    let content: String
    let username: String
    let createdAt: String
    let userProfile: String
    let pictures: [String]
    let pureDegree: Int
    
    func convertModel() -> FeedReviewModel {
        FeedReviewModel(
            identifier: "",
            imageURLStrings: pictures,
            author: username,
            authorProfileURL: userProfile,
            satisfactionValue: pureDegree,
            satisfactionLevel: SatisfactionLevel.calculateSatisfactionLevel(with: pureDegree),
            content: content
        )
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.content = try container.decode(String.self, forKey: .content)
        self.username = try container.decode(String.self, forKey: .username)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.userProfile = try container.decodeIfPresent(String.self, forKey: .userProfile) ?? ""
        self.pictures = try container.decode([String].self, forKey: .pictures)
        self.pureDegree = try container.decode(Int.self, forKey: .pureDegree)
    }
}
