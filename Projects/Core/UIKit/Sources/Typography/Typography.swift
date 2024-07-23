//
//  Typography.swift
//  CoreUIKit
//
//  Created by Ren Shin on 2023/06/18.
//  Copyright © 2023 Swit. All rights reserved.
//

import UIKit
import CoreCommonKit
//import ResourceKit

public struct Typography {
    let size: Size
    let weight: UIFont.Weight
    let alignment: NSTextAlignment
    let color: UIColor
    let applyLineHeight: Bool

    public init(size: Typography.Size,
                weight: UIFont.Weight = .regular,
                alignment: NSTextAlignment = .left,
                color: UIColor,
                applyLineHeight: Bool = true) {
        self.size = size
        self.weight = weight
        self.alignment = alignment
        self.color = color
        self.applyLineHeight = applyLineHeight
    }

    public func createLineHeightAttributes(with lineBreakMode: NSLineBreakMode? = nil) -> [NSAttributedString.Key: Any] {
        let lineHeight = size.lineHeight
        let adjustment = lineHeight >= font.lineHeight ? 2.0 : 1.0
        let baselineOffset = (lineHeight - font.lineHeight) / 2.0 / adjustment

        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        style.alignment = alignment
        

        if let lineBreakMode {
            style.lineBreakMode = lineBreakMode
        }

        return [
            .paragraphStyle: style,
            .baselineOffset: baselineOffset,
            .font: font,
            .foregroundColor: color
        ]
    }
}

extension Typography {
    public var font: UIFont {
        switch weight {
        case .semibold:
            return .Pretendard.semiBold.font(size: size.rawValue)
        case .medium:
            return .Pretendard.medium.font(size: size.rawValue)
        default:
            return .Pretendard.medium.font(size: size.rawValue)
        }
    }
}
