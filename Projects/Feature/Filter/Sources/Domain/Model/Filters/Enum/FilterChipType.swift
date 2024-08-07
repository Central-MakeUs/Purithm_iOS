//
//  FilterChipType.swift
//  Filter
//
//  Created by 이숭인 on 8/7/24.
//

import Foundation

public enum FilterChipType: String, CaseIterable {
    case spring = "봄"
    case summer = "여름"
    case autumn = "가을"
    case winter = "겨울"
    case backlight = "역광에서"
    case night = "night"
    case daily = "daily"
    
    var title: String {
        return self.rawValue
    }
    
    var identifier: String {
        return self.rawValue
    }
}
