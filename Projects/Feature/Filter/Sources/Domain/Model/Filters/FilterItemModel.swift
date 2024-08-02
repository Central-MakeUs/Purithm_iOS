//
//  FilterItemModel.swift
//  Filter
//
//  Created by 이숭인 on 7/29/24.
//

import Foundation

public struct FilterItemModel {
    let identifier: String
    let filterImageURLString: String
    let planType: PlanType
    let filterTitle: String
    let author: String
    var isLike: Bool
    var likeCount: Int
}

public enum PlanType {
    case free
    case premium
    case premiumPlus
}
