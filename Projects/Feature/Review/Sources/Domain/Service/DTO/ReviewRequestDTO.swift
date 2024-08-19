//
//  ReviewRequestDTO.swift
//  Review
//
//  Created by 이숭인 on 8/18/24.
//

import Foundation

public struct ReviewRequestDTO {
    let filterID: String
    var satisfactionValue: Int
    var description: String
    var uploadedURLStrings: [String]
    
    func toDictionary() -> [String: Any] {
        [
            "filterId": Int(filterID) ?? .zero,
            "pureDegree": satisfactionValue,
            "content": description,
            "pictures": uploadedURLStrings
        ]
    }
}
