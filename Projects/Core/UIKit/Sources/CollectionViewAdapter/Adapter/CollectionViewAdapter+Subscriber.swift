//
//  CollectionViewAdapter+Subscriber.swift
//  AlamofirePractice
//
//  Created by 이숭인 on 6/13/24.
//

import Combine

extension CollectionViewAdapter: Subscriber {
    public typealias Input = [SectionModelType]
    public typealias Failure = Never

    public func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    public func receive(completion: Subscribers.Completion<Never>) {
        // do nothing
    }

    public func receive(_ input: [SectionModelType]) -> Subscribers.Demand {
        setupInputSectionsIfNeeded(with: input)
        return .none
    }
}
