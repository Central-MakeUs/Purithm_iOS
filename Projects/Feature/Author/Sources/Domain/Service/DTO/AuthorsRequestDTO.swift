//
//  AuthorsRequestDTO.swift
//  Author
//
//  Created by 이숭인 on 8/18/24.
//

import Foundation

public struct AuthorsRequestDTO {
    var sorted: Sort
    
    enum Sort: String {
        case earliest
        case latest
        case filterCountHigh = "filter"
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "sortedBy": sorted.rawValue
        ]
    }
}
