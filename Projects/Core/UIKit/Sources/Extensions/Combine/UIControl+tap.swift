//
//  UIControl+tap.swift
//  CoreFoundationKit
//
//  Created by Ren Shin on 2023/09/04.
//  Copyright © 2023 Swit. All rights reserved.
//

import UIKit
import Combine
import CombineCocoa

public extension UIControl {
    var tap: AnyPublisher<Void, Never> {
        controlEventPublisher(for: .touchUpInside)
            .eraseToAnyPublisher()
    }
}
