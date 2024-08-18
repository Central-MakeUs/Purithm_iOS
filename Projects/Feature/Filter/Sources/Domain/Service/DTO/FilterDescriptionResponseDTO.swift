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
    
    struct PhotoDescription: Codable {
        var title: String
        var description: String
        var picture: String
        
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
