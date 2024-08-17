//
//  LoginViewModel.swift
//  Login
//
//  Created by 이숭인 on 7/17/24.
//

import UIKit
import Combine
import CorePurithmAuth


extension LoginViewModel {
    struct Input {
        let kakaoLoginButtonTapEvent: AnyPublisher<Void, Never>
    }
    
    struct Output {
        
    }
}

final class LoginViewModel {
    weak var coordinator: LoginCoordinatorable?
    var cancellables = Set<AnyCancellable>()
    
    private let signInUseCase: SignInUseCase
    
    private let errorSubject = PassthroughSubject<Error, Never>()
    var errorPublisher: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    init(coordinator: LoginCoordinatorable, useCase: SignInUseCase) {
        self.coordinator = coordinator
        self.signInUseCase = useCase
    }
    
    func transform(from input: Input) {
        input.kakaoLoginButtonTapEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.signInUseCase.loginWithKakao()
                    .sink { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            self.errorSubject.send(error)
                        }
                    } receiveValue: { _ in
                        self.coordinator?.start()
                    }
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }
    
    func loginWithApple(with idToken: String, name: String) {
        signInUseCase.loginWithApple(with: idToken, name: name)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("::: apple login completed.")
                case .failure(let error):
                    self?.errorSubject.send(error)
                }
            } receiveValue: { [weak self]_ in
                self?.coordinator?.start()
            }
            .store(in: &cancellables)
    }
}

