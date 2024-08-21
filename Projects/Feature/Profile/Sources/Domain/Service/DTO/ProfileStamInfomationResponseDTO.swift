//
//  ProfileStamInfomationResponseDTO.swift
//  Profile
//
//  Created by 이숭인 on 8/21/24.
//

import Foundation
import CoreUIKit

public struct ProfileStamInfomationResponseDTO: Codable {
    let filterId: Int
    let filterName: String
    let photographer: String
    let thumbnail: String
    let createdAt: String
    let membership: String
    let reviewId: Int
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.filterId = try container.decode(Int.self, forKey: .filterId)
        self.filterName = try container.decode(String.self, forKey: .filterName)
        self.photographer = try container.decode(String.self, forKey: .photographer)
        self.thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail) ?? ""
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.membership = try container.decode(String.self, forKey: .membership)
        self.reviewId = try container.decode(Int.self, forKey: .reviewId)
    }
    
    func convertModel() -> ProfileStampInfomationModel {
        ProfileStampInfomationModel(
            filterID: String(filterId),
            filterName: filterName,
            authorName: photographer,
            thumbnailURLString: thumbnail,
            createdAt: createdAt,
            planType: PlanType.calculatePlanType(with: membership),
            reviewID: String(reviewId)
        )
    }
}
