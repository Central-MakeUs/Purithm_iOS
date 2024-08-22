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
    
    private let usecase = ProfileUsecase(
        profileService: ProfileService()
    )
    
    public var type: CoordinatorType { .profile }
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(false, animated: true)
    }
    
    public func start() {
        let viewModel = ProfileViewModel(
            coordinator: self,
            usecase: usecase
        )
        let profileViewController = ProfileViewController(viewModel: viewModel)
        
        self.navigationController.viewControllers = [profileViewController]
    }
    
    public func pushProfileSettingViewContriller() {
        let viewModel = ProfileSettingViewModel(
            coordinator: self,
            usecase: usecase)
        let settingViewController = ProfileSettingViewController(viewModel: viewModel)
        
        self.navigationController.pushViewController(settingViewController, animated: true)
    }
    
    public func pushAccountInfomationViewController() {
        let viewModel = ProfileAccountInfomationViewModel(
            coordinator: self,
            usecase: usecase)
        let accountViewController = ProfileAccountInfomationViewController(viewModel: viewModel)
        
        self.navigationController.pushViewController(accountViewController, animated: true)
    }
    
    public func pushProfileEditViewController() {
        let viewModel = ProfileEditViewModel(
            coordinator: self,
            usecase: usecase)
        let profileEditViewController = ProfileEditViewController(viewModel: viewModel)
        
        self.navigationController.pushViewController(profileEditViewController, animated: true)
    }
}

extension ProfileCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
    }
}

