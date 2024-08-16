//
//  FilterReviewResponseDTO.swift
//  Filter
//
//  Created by 이숭인 on 8/16/24.
//

import Foundation
import CoreCommonKit

public struct FilterReviewResponseDTO: Codable {
    var avg: Int // 평균 퓨어지수
    var reviews: [ReviewDTO]
    
    enum CodingKeys: String, CodingKey {
        case avg, reviews
    }
    
    func convertModel() -> [FilterReviewItemModel] {
        reviews.map { review in
            FilterReviewItemModel(
                identifier: UUID().uuidString,
                thumbnailImageURLString: review.pictures.first ?? "",
                author: review.user,
                date: review.createdAt,
                satisfactionLevel: SatisfactionLevel(rawValue: review.pureDegree) ?? .none
            )
        }
    }
}

struct ReviewDTO: Codable {
    var id: Int
    var pureDegree: Int
    var user: String
    var createdAt: String
    var pictures: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, pureDegree, user, createdAt, pictures
    }
}
