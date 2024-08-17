//
//  FilterDetailModel.swift
//  Filter
//
//  Created by 이숭인 on 7/30/24.
//

import Foundation

struct FilterDetailModel {
    var detailInformation: DetailInformation
    let detailImages: [DetailImageModel]
    var isShowOriginal: Bool
    
    struct DetailInformation {
        let title: String
        let satisfaction: Int // 만족도
        var isLike: Bool
        var likeCount: Int
    }
    
    struct DetailImageModel {
        let identifier: String
        let imageURLString: String
        let originalImageURLString: String
    }
}
