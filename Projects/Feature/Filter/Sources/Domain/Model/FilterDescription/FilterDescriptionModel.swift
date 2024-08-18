//
//  FilterDescriptionModel.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import Foundation

struct FilterDescriptionModel {
    let authorID: String
    let authorName: String
    let authorProfileImageURLString: String
    let authorDescription: String
    let photos: [PhotoDescription]
    let tags: [String]
    
    struct PhotoDescription {
        let title: String
        let description: String
        let imageURLString: String
    }
}

