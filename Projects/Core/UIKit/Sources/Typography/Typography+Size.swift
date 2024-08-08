//
//  Typography+Size.swift
//  CoreUIKit
//
//  Created by Ren Shin on 2023/06/21.
//  Copyright © 2023 Swit. All rights reserved.
//

import UIKit

extension Typography {
    public enum Size: CGFloat {
        case size10 = 10
        case size11, size12, size13, size14, size15, size16, size17, size18, size19, size20
        case size21, size22, size23, size24, size25, size26, size27, size28, size29, size30
        case size31, size32
        case size36
    }
}

extension Typography.Size {
    public var lineHeight: CGFloat {
        switch self {
        case .size10:
            return 12
        case .size11:
            return 14
        case .size12:
            return 16
        case .size13:
            return 18
        case .size14:
            return 20
        case .size15:
            return 21
        case .size16, .size17, .size18, .size19:
            return 22
        case .size20, .size21:
            return 25
        case .size22, .size23:
            return 28
        case .size24, .size25:
            return 30
        case .size26:
            return 32
        case .size27:
            return 34
        case .size28, .size29:
            return 36
        case .size30, .size31, .size32:
            return 39
        case .size36:
            return 47
        }
    }
}
