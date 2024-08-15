//
//  FilterChipType.swift
//  Filter
//
//  Created by 이숭인 on 8/7/24.
//

import Foundation

public enum FilterChipType: String, CaseIterable {
    case all = "전체"
    case brightSpringDay = "화사한 봄날"
    case summerLight = "여름빛"
    case autumnScenery = "가을 풍경"
    case winterSnow = "겨울눈"
    case backlight = "역광에서"
    case night = "night"
    case daily = "daily"
    case cat = "고양이"
    
    var title: String {
        return self.rawValue
    }
    
    var tag: String {
        switch self {
        case .all:
            return ""
        case .brightSpringDay:
            return "spring"
        case .summerLight:
            return "summer"
        case .autumnScenery:
            return "fall"
        case .winterSnow:
            return "winter"
        case .backlight:
            return "backlight"
        case .night:
            return "night"
        case .daily:
            return "daily"
        case .cat:
            return "cat"
        }
    }
    
    var identifier: String {
        return self.rawValue
    }
}
