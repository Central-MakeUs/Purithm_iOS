//
//  PurithmBarButtonItem.swift
//  SwitDesignSystemApp
//
//  Created by Zoe on 2023/05/12.
//

import UIKit
import CoreCommonKit

public final class PurithmBarButtonItem: UIBarButtonItem {
    public let button = UIButton()

    public init(text: String?, tintColor: UIColor) {
        super.init()

        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(tintColor, for: .normal)
        button.backgroundColor = .clear

        let textSize = (text ?? "").size(withAttributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)
        ])
        button.frame = CGRect(origin: .zero, size: CGSize(width: textSize.width + 16, height: 40))
        customView = button
    }

    public init(image: UIImage?, tintColor: UIColor) {
        super.init()

        button.setImage(image, for: .normal)
        button.tintColor = tintColor
        button.adjustsImageWhenHighlighted = false
        button.backgroundColor = .clear

        button.frame = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))
        customView = button
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
