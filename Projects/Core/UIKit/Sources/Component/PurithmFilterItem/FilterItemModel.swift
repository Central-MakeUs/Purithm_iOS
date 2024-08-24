//
//  FilterItemModel.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/9/24.
//

import Foundation

public struct FilterItemModel {
    public let identifier: String
    public let filterImageURLString: String
    public let planType: PlanType
    public let filterTitle: String
    public let author: String
    public let authorID: String
    public var isLike: Bool
    public var likeCount: Int
    public let canAccess: Bool
    
    public init(identifier: String, filterImageURLString: String, planType: PlanType, filterTitle: String, author: String, authorID: String, isLike: Bool, likeCount: Int, canAccess: Bool) {
        self.identifier = identifier
        self.filterImageURLString = filterImageURLString
        self.planType = planType
        self.filterTitle = filterTitle
        self.author = author
        self.authorID = authorID
        self.isLike = isLike
        self.likeCount = likeCount
        self.canAccess = canAccess
    }
}

public enum PlanType {
    case free
    case premium
    case premiumPlus
    
    public var title: String {
        switch self {
        case .free:
            return "basic"
        case .premium:
            return "premium"
        case .premiumPlus:
            return "premium +"
        }
    }
    
    public static func calculatePlanType(with membership: String) -> PlanType {
        switch membership {
        case "BASIC":
            return .free
        case "PREMIUM":
            return .premium
        case "PREMIUM_PLUS":
            return .premiumPlus
        default:
            return .free
        }
    }
}
