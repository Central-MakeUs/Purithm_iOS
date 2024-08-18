//
//  AuthorFiltersRequestDTO.swift
//  Author
//
//  Created by 이숭인 on 8/18/24.
//

import Foundation

public struct AuthorFiltersRequestDTO {
    var authorID: String
    let platform: String = "iOS"
    var sortedBy: Sort
    var page: Int
    var size: Int
    
    enum Sort: String {
        case earliest
        case latest
        case pureIndexHigh
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": authorID,
            "sortedBy": sortedBy.rawValue,
            "os": platform,
            "page": page,
            "size": size
        ]
    }
}
