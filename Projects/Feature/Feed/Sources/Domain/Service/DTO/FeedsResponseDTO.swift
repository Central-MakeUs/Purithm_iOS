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
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.filterId = try container.decode(Int.self, forKey: .filterId)
        self.filterName = try container.decode(String.self, forKey: .filterName)
        self.writer = try container.decode(String.self, forKey: .writer)
        self.profile = try container.decodeIfPresent(String.self, forKey: .profile) ?? ""
        self.pureDegree = try container.decode(Int.self, forKey: .pureDegree)
        self.content = try container.decode(String.self, forKey: .content)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.pictures = try container.decode([String].self, forKey: .pictures)
        self.id = try container.decode(Int.self, forKey: .id)
        self.filterThumbnail = try container.decode(String.self, forKey: .filterThumbnail)
    }
    
    func retriveFilterInformation() -> (name: String, thumbnail: String) {
        return (filterName, filterThumbnail)
    }
    
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
