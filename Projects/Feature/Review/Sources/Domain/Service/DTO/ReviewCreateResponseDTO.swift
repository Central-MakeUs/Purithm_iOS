//
//  ReviewResponseDTO.swift
//  Review
//
//  Created by 이숭인 on 8/18/24.
//

import Foundation

public struct ReviewCreateResponseDTO: Codable {
    let reviewID: Int
    
    enum CodingKeys: String, CodingKey {
        case reviewID = "id"
    }
}
