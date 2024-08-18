//
//  FeedsResponseDTO.swift
//  Feed
//
//  Created by 이숭인 on 8/18/24.
//

import Foundation
import CoreUIKit
import CoreCommonKit

public struct FeedsResponseDTO: Codable {
    let filterId: Int
    let filterName: String
    let writer: String
    let profile: String
    let pureDegree: Int
    let content: String
    let createdAt: String
    let pictures: [String]
    let id: Int
    let filterThumbnail: String
    
    func convertModel() -> FeedReviewModel {
        FeedReviewModel(
            identifier: "\(filterId)",
            imageURLStrings: pictures,
            author: writer,
            authorProfileURL: profile, 
            satisfactionValue: pureDegree,
            satisfactionLevel: SatisfactionLevel.calculateSatisfactionLevel(with: pureDegree),
            content: content
        )
    }
}
