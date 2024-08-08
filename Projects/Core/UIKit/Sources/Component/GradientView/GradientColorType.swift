//
//  GradientColorType.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/5/24.
//

import Foundation

public enum GradientColorType {
    case blue(direction: GradientDirection)
    case purple(direction: GradientDirection)
    case white(direction: GradientDirection)
}

public enum GradientDirection {
    case top
    case leading
    case trailing
    case bottom
}
