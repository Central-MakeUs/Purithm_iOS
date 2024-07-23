//
//  LineHeightSettable.swift
//  CoreUIKit
//
//  Created by Ren Shin on 2023/06/22.
//  Copyright © 2023 Swit. All rights reserved.
//

import UIKit
import Combine
import CombineCocoa

protocol LineHeightSettable: UIView {
    var attributed: NSAttributedString? { get set }
    func applyLineHeight(with typography: Typography, fontLineHeight: CGFloat)
}

private enum AssociatedKeys {
    static var attributedTextCancellable: UInt8 = 0
}

extension LineHeightSettable {
    private var attributedTextCancellable: AnyCancellable? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.attributedTextCancellable) as? AnyCancellable }
        set { objc_setAssociatedObject(self, &AssociatedKeys.attributedTextCancellable, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func applyLineHeight(with typography: Typography, fontLineHeight: CGFloat) {
        guard typography.applyLineHeight else { return }

        setupInitialAttributedTextIfNeeded(with: typography)
        setupTypingAttributesIfNeeded(with: typography)

        initCancellables()
        observeAttributedText(with: typography)
    }
}

// MARK: - setup initial attributed text
extension LineHeightSettable {
    // label의 경우 자기 자신의 높이를 처음에는 lineHeight가 잡히지 않은 상황에서 크기를 잡는다. 그래서 초기화시에 미리 lineHeight를 넣어주어 크기를 제대로 잡아주자
    private func setupInitialAttributedTextIfNeeded(with typography: Typography) {
        guard let label = self as? UILabel else { return }
        let attributedText = label.attributedText ?? NSAttributedString(string: label.text ?? " ")
        bindConvetedAttributeText(with: attributedText, typography: typography)
    }
}

// MARK: - setup typingAttributes
extension LineHeightSettable {
    private func setupTypingAttributesIfNeeded(with typography: Typography) {
        let lineHeightAttributes = typography.createLineHeightAttributes()
        if let textView = self as? UITextView {
            textView.typingAttributes = lineHeightAttributes
        } else if let textField = self as? UITextField {
            textField.typingAttributes = lineHeightAttributes
        }
    }
}

// MARK: - observe attribute text
extension LineHeightSettable {
    private func initCancellables() {
        attributedTextCancellable?.cancel()
    }

    private func observeAttributedText(with typography: Typography) {
        attributedTextCancellable = getAttributedTextPublisher()
            .dropFirst() // 초기화때도 넘어오기 때문에 한번 drop 해준다.
            .removeDuplicates()
            .compactMap { $0 }
            .sink { [weak self] attributedText in
                guard let self else { return }
                // attributedText를 넣으면 publisher가 동작하기 때문에 cancel 후 다시 observe 해준다.
                self.attributedTextCancellable?.cancel()
                self.bindConvetedAttributeText(with: attributedText, typography: typography)
                self.observeAttributedText(with: typography)
                // typingAttributes는 자동으로 초기화 되기 때문에 다시 설정해준다.
                self.setupTypingAttributesIfNeeded(with: typography)
            }
    }

    private func bindConvetedAttributeText(with attributedText: NSAttributedString, typography: Typography) {
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
        // 기존 속성에 lineHeight attributes 적용
        let lineBreakMode: NSLineBreakMode? = {
            if let label = self as? UILabel, label.numberOfLines > 0 {
                return label.lineBreakMode
            } else {
                return nil
            }
        }()
        let lineHeightAttributes = typography.createLineHeightAttributes(with: lineBreakMode)
        mutableAttributedText.addAttributes(lineHeightAttributes,
                                            range: NSRange(location: 0, length: mutableAttributedText.length))
        // 기존 속성을 돌며 paragraphStyle | baselineOffset | font | foregroundColor가 있는 경우 override하여 원복 시켜줌
        attributedText.enumerateAttributes(in: NSRange(location: 0, length: attributedText.length)) { attributes, range, _ in
            if let style = attributes[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle {
                if style.minimumLineHeight == .zero, style.maximumLineHeight == .zero {
                    style.minimumLineHeight = typography.size.lineHeight
                    style.maximumLineHeight = typography.size.lineHeight
                }
                mutableAttributedText.addAttribute(.paragraphStyle, value: style, range: range)
            }

            if let baselineOffset = attributes[NSAttributedString.Key.baselineOffset] as? Double {
                mutableAttributedText.addAttribute(.baselineOffset, value: baselineOffset, range: range)
            }

            if let font = attributes[NSAttributedString.Key.font] as? UIFont {
                mutableAttributedText.addAttribute(.font, value: font, range: range)
            }

            if let foregroundColor = attributes[NSAttributedString.Key.foregroundColor] as? UIColor {
                mutableAttributedText.addAttribute(.foregroundColor, value: foregroundColor, range: range)
            }
        }

        attributed = mutableAttributedText
    }
}

extension LineHeightSettable {
    private func getAttributedTextPublisher() -> AnyPublisher<NSAttributedString?, Never> {
        if let label = self as? UILabel {
            return label.publisher(for: \.attributedText).eraseToAnyPublisher()
        } else if let textField = self as? UITextField {
            return textField.publisher(for: \.attributedText).eraseToAnyPublisher()
        } else if let textView = self as? UITextView {
            return textView.attributedTextPublisher
        } else {
            return Empty().eraseToAnyPublisher()
        }
    }
}
