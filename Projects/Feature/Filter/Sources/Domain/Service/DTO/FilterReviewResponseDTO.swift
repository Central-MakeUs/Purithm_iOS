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
                authorProfileURL: review.profile,
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
    }

}
