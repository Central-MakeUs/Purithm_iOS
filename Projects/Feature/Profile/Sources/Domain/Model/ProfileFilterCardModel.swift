//
//  ProfileFilterCardModel.swift
//  Profile
//
//  Created by 이숭인 on 8/23/24.
//

import Foundation
import CoreUIKit

struct ProfileFilterCardModel {
    let filterId: String
    let filterName: String
    let thumbnailURLString: String
    let author: String
    let hasReview: Bool
    let reviewId: String
    let planType: PlanType
    let createdAt: String
}

