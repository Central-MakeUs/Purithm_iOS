//
//  UIControl+Extension.swift
//  ProtocolDrivenCellBuilder
//
//  Created by 이숭인 on 6/10/24.
//

import UIKit
import Combine
import CombineCocoa

public extension UIControl {
    var tap: AnyPublisher<Void, Never> {
        controlEventPublisher(for: .touchUpInside)
            .eraseToAnyPublisher()
    }
    
    var pressed: AnyPublisher<Void, Never> {
        controlEventPublisher(for: .touchDown)
            .eraseToAnyPublisher()
    }
}
