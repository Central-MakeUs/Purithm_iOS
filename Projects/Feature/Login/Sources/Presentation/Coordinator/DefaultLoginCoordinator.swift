//
//  DefaultLoginCoordinator.swift
//  Login
//
//  Created by 이숭인 on 7/17/24.
//

import UIKit
import CoreCommonKit
import CorePurithmAuth

public final class DefaultLoginCoordinator: LoginCoordinator {
    public var finishDelegate: CoordinatorFinishDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .login }
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    public func start() {
        let useCase = SignInUseCase(repository: AuthRepository())
        
        if useCase.isAlreadyLoggedIn() {
            finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        } else {
            let loginViewModel = LoginViewModel(
                coordinator: self,
                useCase: useCase
            )
            
            let loginViewController = LoginViewController(viewModel: loginViewModel)
            self.navigationController.viewControllers = [loginViewController]

        }
    }
    
    public func finish() {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    public func pushTermsViewController() {
        let viewModel = TermsAndConditionsViewModel(coordinator: self)
        let termsAndConditionsVC = TermsAndConditionsViewController(viewModel: viewModel)
        
        self.navigationController.pushViewController(termsAndConditionsVC, animated: true)
    }
}


//2. 실제 뷰 그려보자 로그인 플로우만
//3. 테스트플라이트 검토해보자
