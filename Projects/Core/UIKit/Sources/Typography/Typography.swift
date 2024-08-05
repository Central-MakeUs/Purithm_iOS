//
//  Typography.swift
//  CoreUIKit
//
//  Created by Ren Shin on 2023/06/18.
//  Copyright © 2023 Swit. All rights reserved.
//

import UIKit
import CoreCommonKit

public struct Typography {
    let size: Size
    let weight: UIFont.Weight
    let alignment: NSTextAlignment
    let color: UIColor
    private var language: Language = .korean
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
    
    public mutating func updateFontTypeForLanguage(for text: String?) {
        guard let text = text else { return }
        let isKorean = text.range(of: "\\p{Hangul}", options: .regularExpression) != nil
        let isEnglish = text.range(of: "\\p{Latin}", options: .regularExpression) != nil
        let containsNumber = text.range(of: "\\d", options: .regularExpression) != nil
        
        if isEnglish || containsNumber {
            language = .english
        } else {
            language = .korean
        }
    }
}

extension Typography {
    public var font: UIFont {
        switch weight {
        case .semibold:
            switch language {
            case .korean:
                return .Pretendard.semiBold.font(size: size.rawValue)
            case .english:
                return .EBGaramond.semiBold.font(size: size.rawValue)
            }
        case .medium:
            switch language {
            case .korean:
                return .Pretendard.medium.font(size: size.rawValue)
            case .english:
                return .EBGaramond.medium.font(size: size.rawValue)
            }
        default:
            switch language {
            case .korean:
                return .Pretendard.medium.font(size: size.rawValue)
            case .english:
                return .EBGaramond.medium.font(size: size.rawValue)
            }
        }
    }
}
