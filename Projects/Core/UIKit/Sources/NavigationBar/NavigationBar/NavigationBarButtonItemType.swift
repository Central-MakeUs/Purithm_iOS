//
//  NavigationBarButtonItemType.swift
//  CoreUIKit
//
//  Created by yeonhwas on 2022/04/13.
//

import UIKit
import CoreCommonKit

public extension Array where Element == NavigationBarButtonItemType {
    static func backItems(for sender: UIViewController) -> Self {
        Element.backItems(for: sender)
    }
}
//
fileprivate extension NavigationBarButtonItemType {
    static func backItems(for sender: UIViewController) -> [NavigationBarButtonItemType] {
            [.backImage(identifier: sender.canGoBack ? "pop" : "dismiss",
                        image: sender.canGoBack ? .icArrowLeft: .icCancel,
                        color: .gray500) ]
    }
}

public enum NavigationBarButtonItemType: Hashable {
    /// 단순 text
    case text(identifier: String, text: String?, color: UIColor = .gray)
    /// 단순 image
    case image(identifier: String, image: UIImage?, color: UIColor = .gray500, renderingMode: UIImage.RenderingMode = .alwaysTemplate)

    case backText(identifier: String, text: String?, color: UIColor = .gray500, enableAutoClose: Bool = true)
    case backImage(identifier: String, image: UIImage?, color: UIColor = .gray500, enableAutoClose: Bool = true)

    var identifier: String {
        switch self {
        case .text(let identifier, _, _): return identifier
        case .image(let identifier, _, _, _): return identifier
        case .backText(let identifier, _, _, _): return identifier
        case .backImage(let identifier, _, _, _): return identifier
        }
    }

    func makeBarButtonItem() -> UIBarButtonItem {
        switch self {
        case .text(_, let text, let color):
            return PurithmBarButtonItem(text: text, tintColor: color)

        case .image(_, let image, let color, let renderingMode):
            return PurithmBarButtonItem(image: image, tintColor: color)

        case .backText(_, let text, let color, _):
            return PurithmBarButtonItem(text: text, tintColor: color)

        case .backImage(_, let image, let color, _):
            return PurithmBarButtonItem(image: image, tintColor: color)
        }
    }
}
