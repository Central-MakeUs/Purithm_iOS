//
//  DefaultLoginCoordinator.swift
//  Login
//
//  Created by 이숭인 on 7/17/24.
//

import UIKit
import CoreCommonKit
import CorePurithmAuth
import Combine
import CoreNetwork
import Moya

public final class LoginCoordinator: LoginCoordinatorable {
    public var finishDelegate: CoordinatorFinishDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .login }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let signInUseCase = SignInUseCase(
        repository: AuthRepository(),
        authService: PurithmAuthService()
    )
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    public func start() {
        signInUseCase.isAlreadyLoggedIn()
            .sink { [weak self] completion in
                guard let self else { return }
                
                switch completion {
                case .finished:
                    self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
                case .failure(let error):
                    switch error {
                    case let error as PurithmAuthError:
                        switch error {
                        case .termsOfServiceRequired:
                            self.pushTermsViewController()
                        case .invalidToken, .invalidErrorType:
                            self.pushOnboardingViewController()
                        default:
                            break
                        }
                    default:
                        print(" invalid error Type > \(error) ")
                        self.pushOnboardingViewController()
                    }
                }
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)
    }
    
    private func pushOnboardingViewController() {
        let onboardingViewModel = OnboardingViewModel(coordinator: self)
        let onboardingViewController = OnboardingPageViewController(viewModel: onboardingViewModel)
        
        self.navigationController.viewControllers = [onboardingViewController]
    }
    
    public func finish() {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    public func pushLoginViewController() {
        let loginViewModel = LoginViewModel(
            coordinator: self,
            useCase: signInUseCase
        )
        
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        self.navigationController.pushViewController(loginViewController, animated: true)
    }
    
    
    public func pushTermsViewController() {
        let viewModel = TermsAndConditionsViewModel(
            coordinator: self,
            useCase: signInUseCase
        )
        let termsAndConditionsVC = TermsAndConditionsViewController(viewModel: viewModel)
        
        self.navigationController.pushViewController(termsAndConditionsVC, animated: true)
    }
}
