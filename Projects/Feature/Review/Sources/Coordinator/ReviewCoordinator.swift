//
//  ReviewCoordinator.swift
//  Review
//
//  Created by 이숭인 on 8/9/24.
//

import UIKit
import CoreCommonKit

public final class ReviewCoordinator: ReviewCoordinatorable {
    public var finishDelegate: CoordinatorFinishDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .review }
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    public func start() {
        let viewModel = ReviewViewModel(coordinator: self)
        let reviewViewController = ReviewViewController(viewModel: viewModel)
        self.navigationController.setNavigationBarHidden(false, animated: false)
        
        self.navigationController.pushViewController(reviewViewController, animated: true)
    }
}
