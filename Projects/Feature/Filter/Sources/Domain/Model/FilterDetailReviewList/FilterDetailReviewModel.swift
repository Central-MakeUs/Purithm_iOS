//
//  FilterDetailReviewModel.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import Foundation
import CoreCommonKit

struct FilterDetailReviewModel {
    let identifier: String
    let imageURLStrings: [String]
    let author: String
    let authorProfileURL: String
    let satisfactionLevel: SatisfactionLevel
    let content: String
}

