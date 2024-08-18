//
//  AuthorsResponseDTO.swift
//  Author
//
//  Created by 이숭인 on 8/18/24.
//

import Foundation

public struct AuthorsResponseDTO: Codable {
    let id: Int
    let name: String
    let profile: String
    let description: String
    let picture: [String]
    let createdAt: String
    
    func convertModel() -> ArtistScrapModel {
        ArtistScrapModel(
            identifier: "\(id)",
            imageURLStrings: picture,
            artist: name,
            artistProfileURLString: profile,
            content: description
        )
    }
}
