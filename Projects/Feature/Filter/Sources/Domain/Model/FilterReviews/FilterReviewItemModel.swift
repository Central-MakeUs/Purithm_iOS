//
//  FilterReviewItemModel.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import Foundation
import CoreCommonKit

struct FilterReviewItemModel {
    let identifier: String
    let thumbnailImageURLString: String
    let author: String
    let date: String
    let satisfactionLevel: SatisfactionLevel
}
