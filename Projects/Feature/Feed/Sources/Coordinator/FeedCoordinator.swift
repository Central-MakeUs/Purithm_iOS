//
//  FeedCoordinator.swift
//  Feed
//
//  Created by 이숭인 on 8/8/24.
//

import UIKit
import CoreCommonKit
import Filter

public final class FeedsCoordinator: FeedsCoordinatorable {
    public var finishDelegate: CoordinatorFinishDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .feeds }
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    public func start() {
        let viewModel = FeedsViewModel(coordinator: self)
        let feedsViewController = FeedsViewController(viewModel: viewModel)
        
        self.navigationController.viewControllers = [feedsViewController]
    }
    
    public func pushFilterDetail(with filterID: String) {
        let coordinator = FilterDetailCoordinator(self.navigationController)
        coordinator.finishDelegate = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension FeedsCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
    }
}
