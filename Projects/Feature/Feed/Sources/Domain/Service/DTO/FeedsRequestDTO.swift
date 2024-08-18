//
//  FeedsRequestDTO.swift
//  Feed
//
//  Created by 이숭인 on 8/18/24.
//

import Foundation

public struct FeedsRequestDTO {
    let platform: String = "iOS"
    var sortedBy: Sort
    
    enum Sort: String {
        case earliest
        case latest
        case pureIndexHigh
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "os": platform,
            "sortedBy": sortedBy.rawValue
        ]
    }
}
