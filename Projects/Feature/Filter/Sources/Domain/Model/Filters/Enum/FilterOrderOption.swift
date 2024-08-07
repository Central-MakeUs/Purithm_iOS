//
//  FilterOrderOption.swift
//  Filter
//
//  Created by 이숭인 on 8/7/24.
//

import Foundation

public enum FilterOrderOption: String, CaseIterable {
    case earliest
    case latest
    case pureIndexHigh
    
    var identifier: String {
        return self.rawValue
    }
    
    var title: String {
        switch self {
        case .earliest:
            return "최신순"
        case .latest:
            return "오래된순"
        case .pureIndexHigh:
            return "퓨어지수 높은순"
        }
    }
}
