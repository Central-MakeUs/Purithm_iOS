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

public final class LoginCoordinator: LoginCoordinatorable {
    public var finishDelegate: CoordinatorFinishDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .login }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let signInUseCase = SignInUseCase(repository: AuthRepository())
    
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
                case .failure:
                    //TODO: 에러처리 (이용약관 혹은 로그인 화면 플로우)
                    let onboardingViewModel = OnboardingViewModel(coordinator: self)
                    let onboardingViewController = OnboardingPageViewController(viewModel: onboardingViewModel)
                    
                    self.navigationController.viewControllers = [onboardingViewController]
                }
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)
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
        let viewModel = TermsAndConditionsViewModel(coordinator: self)
        let termsAndConditionsVC = TermsAndConditionsViewController(viewModel: viewModel)
        
        self.navigationController.pushViewController(termsAndConditionsVC, animated: true)
    }
}
