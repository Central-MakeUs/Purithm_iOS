//
//  AppCoordinator.swift
//  Purithm
//
//  Created by 이숭인 on 7/17/24.
//

import UIKit
import CoreCommonKit
import CoreUIKit
import Login // TODO: 이름 바꾸자 - PurithmLogin ??

final class DefaultAppCoordinator: AppCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .app }
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func start() {
        self.showLoginFlow()
    }
    
    func showLoginFlow() {
        let loginCoordinator = LoginCoordinator(self.navigationController)
        loginCoordinator.finishDelegate = self
        loginCoordinator.start()
        
        childCoordinators.append(loginCoordinator)
    }
    
    func showTabBarFlow() {
        let homeCoordinator = DefaultTabBarCoordinator(self.navigationController)
        homeCoordinator.finishDelegate = self
        homeCoordinator.start()
        
        childCoordinators.append(homeCoordinator)
    }
}

extension DefaultAppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        // 넘어온 코디네이터 타입을 필터링하여 부모코디네이터와의 인력을 끊는다.
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
        
        self.navigationController.view.backgroundColor = .systemBackground
        self.navigationController.viewControllers.removeAll()
        
        switch childCoordinator.type {
        case .tab:
            self.navigationController.setNavigationBarHidden(true, animated: false)
            self.showLoginFlow()
        case .login:
            self.navigationController.setNavigationBarHidden(true, animated: false)
            self.showTabBarFlow()
        default:
            break
        }
    }
}
