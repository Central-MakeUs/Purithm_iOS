//
//  FilterListResponseDTO.swift
//  Filter
//
//  Created by 이숭인 on 8/14/24.
//

import Foundation
import CoreUIKit

public struct FilterListResponseDTO: Codable {
    let isLast: Bool
    let filters: [Filter]
}

struct Filter: Codable {
    let id: Int
    let membership: String
    let name: String
    let thumbnail: String
    let photographerId: Int
    let photographerName: String
    let likes: Int
    let canAccess: Bool
    let liked: Bool
    
    func convertModel() -> FilterItemModel {
        FilterItemModel(
            identifier: "\(UUID().uuidString)_\(id)",
            filterImageURLString: thumbnail,
            planType: PlanType.calculatePlanType(with: membership),
            filterTitle: name,
            author: photographerName,
            authorID: "\(photographerId)",
            isLike: liked,
            likeCount: likes,
            canAccess: canAccess
        )
    }
}
