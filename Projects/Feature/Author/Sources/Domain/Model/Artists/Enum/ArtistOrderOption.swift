//
//  ArtistOrderOption.swift
//  Author
//
//  Created by 이숭인 on 8/8/24.
//

import Foundation

enum ArtistOrderOption: String, CaseIterable {
    case filterCountHigh
    case earliest
    case latest
    
    var identifier: String {
        return self.rawValue
    }
    
    var title: String {
        switch self {
        case .filterCountHigh:
            return "필터 많은순"
        case .earliest:
            return "최신순"
        case .latest:
            return "오래된순"
        }
    }
}
