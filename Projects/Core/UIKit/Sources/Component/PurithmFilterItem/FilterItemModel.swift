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
    public var isLike: Bool
    public var likeCount: Int
    public let canAccess: Bool
    
    public init(identifier: String, filterImageURLString: String, planType: PlanType, filterTitle: String, author: String, isLike: Bool, likeCount: Int, canAccess: Bool) {
        self.identifier = identifier
        self.filterImageURLString = filterImageURLString
        self.planType = planType
        self.filterTitle = filterTitle
        self.author = author
        self.isLike = isLike
        self.likeCount = likeCount
        self.canAccess = canAccess
    }
}

public enum PlanType {
    case free
    case premium
    case premiumPlus
}