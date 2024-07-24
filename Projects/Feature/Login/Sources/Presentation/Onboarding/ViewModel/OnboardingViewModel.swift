//
//  OnboardingViewModel.swift
//  Login
//
//  Created by 이숭인 on 7/24/24.
//

import UIKit
import Combine

extension OnboardingViewModel {
    struct Input {
        let loginTapEvent: AnyPublisher<Void, Never>
    }
}

final class OnboardingViewModel {
    weak var coordinator: LoginCoordinatorable?
    var cancellables = Set<AnyCancellable>()
    
    init(coordinator: LoginCoordinatorable) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) {
        input.loginTapEvent
            .sink { [weak self] _ in
                self?.coordinator?.pushLoginViewController()
            }
            .store(in: &cancellables)
    }
}
