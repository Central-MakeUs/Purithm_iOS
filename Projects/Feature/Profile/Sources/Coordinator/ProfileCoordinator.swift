//
//  ProfileCoordinator.swift
//  Profile
//
//  Created by 이숭인 on 8/19/24.
//

import UIKit
import CoreCommonKit

public final class ProfileCoordinator: ProfileCoordinatorable {
    public var finishDelegate: CoordinatorFinishDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    
    public var type: CoordinatorType { .profile }
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let viewModel = ProfileViewModel(coordinator: self)
        let profileViewController = ProfileViewController(viewModel: viewModel)
        
        self.navigationController.viewControllers = [profileViewController]
    }
}

extension ProfileCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
    }
}

