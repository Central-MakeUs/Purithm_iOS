//
//  NavigationBarType.swift
//  Swit-iOS
//
//  Created by Ren Shin on 2023/07/03.
//  Copyright © 2023 Swit. All rights reserved.
//

import UIKit
import CoreCommonKit

public enum NavigationBarType {
    case page

    var statusBarStyle: UIStatusBarStyle {
        .default
    }

    var backgroundColor: UIColor {
        .gray100
    }

    var titlePositionAdjustment: UIOffset {
        .zero
    }

    var textAlignment: NSTextAlignment {
        switch self {
        case .page: return .center
        }
    }
}
