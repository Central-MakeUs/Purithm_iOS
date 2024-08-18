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
    case none = 0
    
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
        case .none:
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
        case .none:
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
        case .none:
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
        case .none:
            return .bgReview0
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
        case .none:
            return .bgReview0
        }
    }
    
    public static func calculateSatisfactionLevel(with averageValue: Int) -> SatisfactionLevel {
        switch averageValue {
        case 20...30:
            return SatisfactionLevel.low
        case 31...50:
            return SatisfactionLevel.medium
        case 51...70:
            return SatisfactionLevel.mediumHigh
        case 71...90:
            return SatisfactionLevel.high
        case 91...100:
            return SatisfactionLevel.veryHigh
        default:
            return SatisfactionLevel.none
        }
    }
}
