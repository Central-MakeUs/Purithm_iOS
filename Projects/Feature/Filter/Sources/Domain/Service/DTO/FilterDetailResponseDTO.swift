//
//  FilterDetailResponseDTO.swift
//  Filter
//
//  Created by 이숭인 on 8/15/24.
//

import Foundation

public struct FilterDetailResponseDTO: Codable {
    let name: String
    let likes: Int
    let pureDegree: Int
    let pictures: [Picture]
    let liked: Bool
    
    struct Picture: Codable {
        let picture: String
        let originalPicture: String
    }
    
    func convertModel() -> FilterDetailModel {
        FilterDetailModel(
            detailInformation:
                FilterDetailModel.DetailInformation(
                    title: name,
                    satisfaction: pureDegree,
                    isLike: liked,
                    likeCount: likes
                ),
            detailImages: pictures.map {
                FilterDetailModel.DetailImageModel(
                    identifier: $0.picture,
                    imageURLString: $0.picture,
                    originalImageURLString: $0.originalPicture
                )
            }, isShowOriginal: false
        )
    }
}

