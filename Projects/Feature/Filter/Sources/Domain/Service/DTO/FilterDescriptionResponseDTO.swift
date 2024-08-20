//
//  FilterDescriptionResponseDTO.swift
//  Filter
//
//  Created by 이숭인 on 8/18/24.
//

import Foundation

public struct FilterDescriptionResponseDTO: Codable {
    var photographerId: Int
    var name: String
    var profile: String
    var description: String
    var photoDescriptions: [PhotoDescription]
    var tag: [String]
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.photographerId = try container.decode(Int.self, forKey: .photographerId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.profile = try container.decodeIfPresent(String.self, forKey: .profile) ?? ""
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.photoDescriptions = try container.decodeIfPresent([FilterDescriptionResponseDTO.PhotoDescription].self, forKey: .photoDescriptions) ?? []
        self.tag = try container.decodeIfPresent([String].self, forKey: .tag) ?? []
    }
    
    struct PhotoDescription: Codable {
        var title: String
        var description: String
        var picture: String
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<FilterDescriptionResponseDTO.PhotoDescription.CodingKeys> = try decoder.container(keyedBy: FilterDescriptionResponseDTO.PhotoDescription.CodingKeys.self)
            self.title = try container.decodeIfPresent(String.self, forKey: FilterDescriptionResponseDTO.PhotoDescription.CodingKeys.title) ?? ""
            self.description = try container.decodeIfPresent(String.self, forKey: FilterDescriptionResponseDTO.PhotoDescription.CodingKeys.description) ?? ""
            self.picture = try container.decodeIfPresent(String.self, forKey: FilterDescriptionResponseDTO.PhotoDescription.CodingKeys.picture) ?? ""
        }
        
        func convertModel() -> FilterDescriptionModel.PhotoDescription {
            FilterDescriptionModel.PhotoDescription(
                title: title,
                description: description,
                imageURLString: picture
            )
        }
    }
    
    func convertModel() -> FilterDescriptionModel {
        FilterDescriptionModel(
            authorID: "\(photographerId)",
            authorName: name,
            authorProfileImageURLString: profile,
            authorDescription: description,
            photos: photoDescriptions.map { $0.convertModel() },
            tags: tag)
    }
}
