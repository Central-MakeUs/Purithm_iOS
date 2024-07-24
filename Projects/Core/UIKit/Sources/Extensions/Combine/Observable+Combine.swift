//
//  Observable+Combine.swift
//  CoreUIKit
//
//  Created by 이숭인 on 7/24/24.
//

import Combine
import RxSwift

extension ObservableType {
    public func asPublisher() -> AnyPublisher<Element, Never> {
        let subject = PassthroughSubject<Element, Never>()
        
        // 구독하여 이벤트를 PassthroughSubject로 전달
        let _ = self.subscribe(
            onNext: { element in
                subject.send(element)
            },
            onError: { error in
                // Combine에서는 Never로 처리되므로 에러를 무시합니다.
                // 에러를 전달하려면 AnyPublisher<Element, Error>로 반환 타입을 변경해야 합니다.
            },
            onCompleted: {
                subject.send(completion: .finished)
            }
        )
        
        return subject.eraseToAnyPublisher()
    }
}

