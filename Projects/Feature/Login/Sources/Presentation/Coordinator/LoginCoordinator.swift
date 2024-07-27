//
//  DefaultLoginCoordinator.swift
//  Login
//
//  Created by 이숭인 on 7/17/24.
//

import UIKit
import CoreCommonKit
import CorePurithmAuth

public final class LoginCoordinator: LoginCoordinatorable {
    public var finishDelegate: CoordinatorFinishDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .login }
    
    private let signInUseCase = SignInUseCase(repository: AuthRepository())
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    public func start() {
        if signInUseCase.isAlreadyLoggedIn() {
            finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        } else {
            let onboardingViewModel = OnboardingViewModel(coordinator: self)
            let onboardingViewController = OnboardingPageViewController(viewModel: onboardingViewModel)
            
            self.navigationController.viewControllers = [onboardingViewController]
        }
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
