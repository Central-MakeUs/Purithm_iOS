//
//  UILabel+Typography.swift
//  CoreUIKit
//
//  Created by Ren Shin on 2023/06/21.
//  Copyright © 2023 Swit. All rights reserved.
//

import UIKit

private enum AssociatedKeys {
    static var typographyKey: UInt8 = 0
}

extension UILabel {
    public var typography: Typography? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.typographyKey) as? Typography }
        set { objc_setAssociatedObject(self, &AssociatedKeys.typographyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

public extension UILabel {
    convenience init(typography: Typography) {
        self.init()
        applyTypography(with: typography)
    }

    func applyTypography(with typography: Typography) {
        font = typography.font
        textAlignment = typography.alignment
        textColor = typography.color

        self.typography = typography
        applyLineHeight(with: typography, fontLineHeight: font.lineHeight)
    }
}

extension UILabel: LineHeightSettable {
    var attributed: NSAttributedString? {
        get { attributedText }
        set { attributedText = newValue }
    }
}
