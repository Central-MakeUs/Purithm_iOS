//
//  FilterReviewResponseDTO.swift
//  Filter
//
//  Created by 이숭인 on 8/16/24.
//

import Foundation
import CoreCommonKit
import CoreUIKit

public struct FilterReviewResponseDTO: Codable {
    var avg: Int // 평균 퓨어지수
    var hasViewed: Bool
    var reviews: [ReviewDTO]
    
    enum CodingKeys: String, CodingKey {
        case avg
        case hasViewed
        case reviews
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.avg = try container.decode(Int.self, forKey: .avg)
        self.hasViewed = try container.decode(Bool.self, forKey: .hasViewed)
        self.reviews = try container.decodeIfPresent([ReviewDTO].self, forKey: .reviews) ?? []
    }
    
    func convertReviewItemModel() -> [FilterReviewItemModel] {
        reviews.map { review in
            FilterReviewItemModel(
                identifier: "\(review.id)",
                thumbnailImageURLString: review.pictures.first ?? "",
                author: review.user,
                date: review.createdAt,
                satisfactionLevel: SatisfactionLevel(rawValue: review.pureDegree) ?? .none
            )
        }
    }
    
    func convertReviewModel() -> [FeedReviewModel] {
        reviews.map { review in
            FeedReviewModel(
                identifier: "\(review.id)",
                imageURLStrings: review.pictures,
                author: review.user,
                authorProfileURL: review.profile, satisfactionValue: review.pureDegree,
                satisfactionLevel: SatisfactionLevel(rawValue: review.pureDegree) ?? .none,
                content: review.content
            )
        }
    }
}


extension FilterReviewResponseDTO {
    struct ReviewDTO: Codable {
        let id: Int
        let pureDegree: Int
        let user: String
        let profile: String
        let content: String
        let createdAt: String
        let pictures: [String]
        
        enum CodingKeys: String, CodingKey {
            case id
            case pureDegree
            case user
            case profile
            case content
            case createdAt
            case pictures
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.pureDegree = try container.decode(Int.self, forKey: .pureDegree)
            self.user = try container.decode(String.self, forKey: .user)
            self.profile = try container.decodeIfPresent(String.self, forKey: .profile) ?? ""
            self.content = try container.decode(String.self, forKey: .content)
            self.createdAt = try container.decode(String.self, forKey: .createdAt)
            self.pictures = try container.decode([String].self, forKey: .pictures)
        }
    }
}
