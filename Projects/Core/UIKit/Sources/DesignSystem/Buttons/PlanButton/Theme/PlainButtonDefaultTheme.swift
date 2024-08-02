//
//  PlainButtonDefaultTheme.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/25/24.
//

import UIKit
import CoreCommonKit

public struct PlainButtonDefaultTheme: PlainButtonThemeType {
    public let defaultBackgroundColor: UIColor = .blue400

    public func fontColor(type: PlainButton.`Type`, variant: PurithmCommonButton.Variant, buttonState: PurithmCommonButton.State) -> UIColor {
        switch (type, variant, buttonState) {
        case (.filled, .secondary, .default): return .blue400
        case (.filled, .secondary, .pressed): return .blue400
        default: return .white
        }
    }

    public func backgroundColors(type: PlainButton.`Type`, variant: PurithmCommonButton.Variant, buttonState: PurithmCommonButton.State) -> UIColor {
        switch (type, variant, buttonState) {
        case (.filled, .default, .default): return .blue400
        case (.filled, .default, .pressed): return .blue500
        case (.filled, .default, .disabled): return .gray200
        case (.filled, .primary, .default): return .blue400
        case (.filled, .primary, .pressed): return .blue500
        case (.filled, .primary, .disabled): return .gray300
        case (.filled, .secondary, .default): return .white
        case (.filled, .secondary, .pressed): return .gray200
        case (.filled, .secondary, .disabled): return .gray200
        case (_, .option, .default): return .white020
        case (_, .option, _): return .black040
        case (.transparent, _, .default): return .blue040
        case (.transparent, _, .pressed): return .blue050
        case (.transparent, _, .disabled): return .black040
        }
    }

    public func highlightDimmedColor(type: PlainButton.`Type`, variant: PurithmCommonButton.Variant, buttonState: PurithmCommonButton.State) -> UIColor {
        switch (type, variant, buttonState) {
        case (.filled, _, _): return .clear
        case (.transparent, _, _): return .clear
        }
    }

    public func borderColors(type: PlainButton.`Type`, variant: PurithmCommonButton.Variant, buttonState: PurithmCommonButton.State) -> CGColor {
        switch (type, variant, buttonState) {
        case (.filled, _, _): return UIColor.clear.cgColor
        case (.transparent, _, _): return UIColor.clear.cgColor
        }
    }
}
