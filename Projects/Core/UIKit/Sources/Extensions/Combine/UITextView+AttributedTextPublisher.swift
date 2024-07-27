//
//  UITextView+AttributedTextPublisher.swift
//  CoreUIKit
//
//  Created by Ren Shin on 2023/07/04.
//  Copyright © 2023 Swit. All rights reserved.
//

import UIKit
import Combine
import CombineCocoa

public extension UITextView {
    var attributedTextPublisher: AnyPublisher<NSAttributedString?, Never> {
        Deferred { [weak textView = self] in
            textView?.textStorage
                .didProcessEditingRangeChangeInLengthPublisher
                .receive(on: DispatchQueue.main)
                .map { _ in textView?.attributedText }
                .prepend(textView?.attributedText)
                .eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
