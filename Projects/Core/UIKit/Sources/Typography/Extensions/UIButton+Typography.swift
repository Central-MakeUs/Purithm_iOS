//
//  UIButton+Typography.swift
//  CoreUIKit
//
//  Created by Ren Shin on 2023/06/21.
//  Copyright © 2023 Swit. All rights reserved.
//

import UIKit

private enum AssociatedKeys {
    static var typographyKey: UInt8 = 0
}

extension UIButton {
    public var typography: Typography? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.typographyKey) as? Typography }
        set { objc_setAssociatedObject(self, &AssociatedKeys.typographyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

public extension UIButton {
    convenience init(typography: Typography, type: ButtonType = .custom) {
        self.init(type: type)
        applyTypography(with: typography)
    }

    func applyTypography(with typography: Typography, for state: UIControl.State = .normal) {
        titleLabel?.font = typography.font
        setTitleColor(typography.color, for: state)

        self.typography = typography
    }
}
