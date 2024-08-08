//
//  ArtistScrapModel.swift
//  Author
//
//  Created by 이숭인 on 8/8/24.
//

import Foundation

struct ArtistScrapModel {
    let identifier: String
    let imageURLStrings: [String]
    let artist: String
    let artistProfileURLString: String
    let content: String
    var scripImageType: ScrapImageType {
        switch imageURLStrings.count {
        case 1:
            return .single
        case 2:
            return .double
        case 3:
            return .thriple
        default:
            return .single
        }
    }
    
    enum ScrapImageType: Int {
        case single = 1
        case double = 2
        case thriple = 3
    }
}
