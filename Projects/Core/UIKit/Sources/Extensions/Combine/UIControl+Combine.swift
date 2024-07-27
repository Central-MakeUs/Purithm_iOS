//
//  UIControl+Extension.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/25/24.
//

import Combine
import UIKit

extension UIControl {
    /// isEnabled 옵션과 함께 alpha값도 조정해주는 변수
    var enabled: Bool {
        get {
            return isEnabled
        } set {
            isEnabled = newValue
            alpha = newValue ? 1 : 0.3
        }
    }
}

// MARK: - CombineCompatible

public protocol CombineCompatible {}
public extension UIControl {
    final class Subscription<SubscriberType: Subscriber, Control: UIControl>: Combine.Subscription where SubscriberType.Input == Control {
        private var subscriber: SubscriberType?
        private let input: Control

        public init(subscriber: SubscriberType, input: Control, event: UIControl.Event) {
            self.subscriber = subscriber
            self.input = input
            input.addTarget(self, action: #selector(eventHandler), for: event)
        }

        public func request(_: Subscribers.Demand) {}

        public func cancel() {
            subscriber = nil
        }

        @objc private func eventHandler() {
            _ = subscriber?.receive(input)
        }
    }

    struct Publisher<Output: UIControl>: Combine.Publisher {
        public typealias Output = Output
        public typealias Failure = Never

        let output: Output
        let event: UIControl.Event

        public init(output: Output, event: UIControl.Event) {
            self.output = output
            self.event = event
        }

        public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Output == S.Input {
            let subscription = Subscription(subscriber: subscriber, input: output, event: event)
            subscriber.receive(subscription: subscription)
        }
    }
}

// MARK: - UIControl + CombineCompatible

extension UIControl: CombineCompatible {}
public extension CombineCompatible where Self: UIControl {
    func publisher(for event: UIControl.Event) -> UIControl.Publisher<UIControl> {
        .init(output: self, event: event)
    }
}

