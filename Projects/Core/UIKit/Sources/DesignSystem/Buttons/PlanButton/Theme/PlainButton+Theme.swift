//
//  PlainButtonType.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/25/24.
//

import UIKit

public protocol PlainButtonThemeType {
    var defaultBackgroundColor: UIColor { get }
    func fontColor(type: PlainButton.`Type`, variant: PurithmCommonButton.Variant, buttonState: PurithmCommonButton.State) -> UIColor
    func backgroundColors(type: PlainButton.`Type`, variant: PurithmCommonButton.Variant, buttonState: PurithmCommonButton.State) -> UIColor
    func highlightDimmedColor(type: PlainButton.`Type`, variant: PurithmCommonButton.Variant, buttonState: PurithmCommonButton.State) -> UIColor
    func borderColors(type: PlainButton.`Type`, variant: PurithmCommonButton.Variant, buttonState: PurithmCommonButton.State) -> CGColor
}

public enum PlainButtonTheme {
    case `default`
    
    var instance: PlainButtonThemeType {
        switch self {
        case .default: return PlainButtonDefaultTheme()
        }
    }
}
