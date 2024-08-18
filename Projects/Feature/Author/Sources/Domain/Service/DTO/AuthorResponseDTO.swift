//
//  AuthorResponseDTO.swift
//  Author
//
//  Created by 이숭인 on 8/18/24.
//

import Foundation
import CoreUIKit

public struct AuthorResponseDTO: Codable {
    let id: Int
    let name: String
    let profile: String
    let description: String
    let picture: [String]
    let createdAt: String
    
    func convertModel() -> PurithmVerticalProfileModel {
        PurithmVerticalProfileModel(
            identifier: "\(id)",
            type: .artist,
            name: name,
            profileURLString: profile,
            introduction: description
        )
    }
}
