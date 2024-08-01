//
//  FilterDetailOptionType.swift
//  Filter
//
//  Created by 이숭인 on 7/31/24.
//

import UIKit
import CoreCommonKit

public enum FilterDetailOptionType: CaseIterable {
    case satisfaction
    case introduction
    
    var title: String {
        switch self {
        case .satisfaction:
            return "필터 만족도"
        case .introduction:
            return "필터 상세"
        }
    }
    
    var leftImage: UIImage {
        switch self {
        case .satisfaction:
            return .icStarHigh
        case .introduction:
            return .icArtistFill
        }
    }
    
    var rightImage: UIImage {
        return .icMove
    }
}
