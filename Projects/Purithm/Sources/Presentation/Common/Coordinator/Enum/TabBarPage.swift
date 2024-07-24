//
//  TabBarPage.swift
//  Purithm
//
//  Created by 이숭인 on 7/17/24.
//

import UIKit
import CoreCommonKit

enum TabBarPage: String, CaseIterable {
    case home, author, collector, mypage
    
    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .author
        case 2: self = .collector
        case 3: self = .mypage
        default: return nil
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .home: return 0
        case .author: return 1
        case .collector: return 2
        case .mypage: return 3
        }
    }
    
    func tabIcon() -> UIImage {
        switch self {
        case .home:
            return .icHome
        case .author:
            return .icArtistOutline
        case .collector:
            return .icCollector
        case .mypage:
            return .icProfile
        }
    }
}
