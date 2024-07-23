//
//  SwiftUI+Typography.swift
//  CoreUIKit
//
//  Created by Chad Kim on 2023/11/24.
//  Copyright © 2023 Swit. All rights reserved.
//

import SwiftUI

public extension UIColor {
    var asColor: Color {
        Color(uiColor: self)
    }
}

public extension View {
    @ViewBuilder
    func applyTypography(with typography: Typography) -> some View {
        self.font(Font(typography.font))
            .foregroundColor(typography.color.asColor)
            .multilineTextAlignment(typography.alignment.asTextAlignment)
        //            .applyLineHeight(with: typography, fontLineHeight: typography.font.lineHeight)
    }

    @ViewBuilder
    private func applyLineHeight(with typography: Typography,
                                 fontLineHeight: CGFloat) -> some View {
        if typography.applyLineHeight {
            modifier(FontLineHeight(font: typography.font, lineHeight: fontLineHeight))
        }
    }
}

fileprivate extension NSTextAlignment {
    var asTextAlignment: TextAlignment {
        switch self {
        case .left:
            return .leading
        case .center:
            return .center
        case .right:
            return .trailing
        case .justified:
            return .center
        case .natural:
            return .center
        @unknown default:
            return .center
        }
    }
}

private struct FontLineHeight: ViewModifier {
    let font: UIFont
    let lineHeight: CGFloat

    func body(content: Content) -> some View {
        content
            .lineSpacing(lineHeight - font.lineHeight)
            .padding(.vertical, (lineHeight - font.lineHeight) / 2)
    }
}
