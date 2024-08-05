//
//  SatisfactionLevel.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import UIKit
import CoreCommonKit

enum SatisfactionLevel: Int {
    case veryHigh = 100
    case high = 80
    case mediumHigh = 60
    case medium = 40
    case low = 20
    
    var color: UIColor {
        switch self {
        case .veryHigh:
            return .purple500
        case .high:
            return .purple400
        case .mediumHigh:
            return .blue300
        case .medium:
            return .blue200
        case .low:
            return .blue100
        }
    }
    
    var circleBackgroundImage: UIImage {
        switch self {
        case .veryHigh:
            return ._101
        case .high:
            return ._102
        case .mediumHigh:
            return ._103
        case .medium:
            return ._104
        case .low:
            return ._105
        }
    }
}
