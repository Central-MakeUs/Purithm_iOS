//
//  FilterDetailModel.swift
//  Filter
//
//  Created by 이숭인 on 7/30/24.
//

import Foundation

struct FilterDetailModel {
    let detailInformation: DetailInformation
    let detailImages: [DetailImageModel]
    
    struct DetailInformation {
        let title: String
        let satisfaction: Int // 만족도
        let isLike: Bool
        let likeCount: Int
    }
    
    struct DetailImageModel {
        let identifier: String
        let imageURLString: String
    }
}
