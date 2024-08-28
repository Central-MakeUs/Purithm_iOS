//
//  FilterListRequestDTO.swift
//  Filter
//
//  Created by 이숭인 on 8/14/24.
//

import Foundation

public struct FilterListRequestDTO {
    let platform: String = "iOS"
    var tag: FilterChipType
    var sortedBy: Sort
    var page: Int
    var size: Int
    
    enum Sort: String {
        case name
        case pureIndexHigh
        case rating = "membership"
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "os": platform,
            "tag": tag.tag,
            "sortedBy": sortedBy.rawValue,
            "page": page,
            "size": size
        ]
    }
}

