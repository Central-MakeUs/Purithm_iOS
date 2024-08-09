//
//  SatisfactionLevel.swift
//  CoreCommonKit
//
//  Created by 이숭인 on 8/5/24.
//

import UIKit

public enum SatisfactionLevel: Int, CaseIterable {
    case veryHigh = 100
    case high = 80
    case mediumHigh = 60
    case medium = 40
    case low = 20
    
    public var color: UIColor {
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
    
    public var starImage: UIImage {
        switch self {
        case .veryHigh, .high:
            return .icStarHigh
        case .mediumHigh:
            return .icStarMedium
        case .medium, .low:
            return .icStarLow
        }
    }
    
    public var circleBackgroundImage: UIImage {
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
    
    public var backgroundStarImage: UIImage {
        switch self {
        case .veryHigh:
            return .bgReview100
        case .high:
            return .bgReview80
        case .mediumHigh:
            return .bgReview60
        case .medium:
            return .bgReview40
        case .low:
            return .bgReview20
        }
    }
    
    public var backgroundSatisfactionImage: UIImage {
        switch self {
        case .veryHigh:
            return .bgReview100
        case .high:
            return .bgReview80
        case .mediumHigh:
            return .bgReview60
        case .medium:
            return .bgReview40
        case .low:
            return .bgReview20
        }
    }
}
