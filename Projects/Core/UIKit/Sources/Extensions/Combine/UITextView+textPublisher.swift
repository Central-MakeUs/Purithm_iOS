//
//  UITextView+textPublisher.swift
//  CoreUIKit
//
//  Created by Ren Shin on 2/15/24.
//  Copyright © 2024 Swit. All rights reserved.
//

import UIKit
import Combine
import CombineCocoa

extension UITextView {
    public var fixedTextPublisher: AnyPublisher<String?, Never> {
        Deferred { [weak textView = self] in
            textView?.textStorage
                .didProcessEditingRangeChangeInLengthPublisher
                .receive(on: DispatchQueue.main)
                .map { _ in textView?.text }
                .prepend(textView?.text)
                .eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
