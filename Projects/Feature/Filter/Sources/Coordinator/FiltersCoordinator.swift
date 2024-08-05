//
//  FiltersCoordinator.swift
//  Filter
//
//  Created by 이숭인 on 7/30/24.
//

import UIKit
import CoreCommonKit

public final class FiltersCoordinator: FiltersCoordinatorable {
    public var finishDelegate: CoordinatorFinishDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .filters }
    
    private let filtersUseCase = FiltersUseCase(
        authService: FiltersService()
    )
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    public func start() {
        let viewModel = FiltersViewModel(coordinator: self)
        let filtersViewController = FiltersViewController(viewModel: viewModel)
        self.navigationController.setNavigationBarHidden(false, animated: false)
        
        self.navigationController.viewControllers = [filtersViewController]
    }
    
    public func finish() {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    public func pushFilterDetail(with filterID: String) {
        let viewModel = FilterDetailViewModel(with: filterID, coordinator: self)
        let filterDetailViewController = FilterDetailViewController(viewModel: viewModel)
        filterDetailViewController.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(filterDetailViewController, animated: true)
    }
    
    public func pushFilterDescription(with filterID: String) {
        let viewModel = FilterDescriptionViewModel(
            filterID: filterID,
            useCase: filtersUseCase
        )
        let filterDescriptionViewController = FilterDescriptionViewController(viewModel: viewModel)
        self.navigationController.pushViewController(filterDescriptionViewController, animated: true)
    }
    
    public func pushFilterReviews(with filterID: String) {
        let viewModel = FilterReviewsViewModel(
            with: filterID,
            usecase: filtersUseCase,
            coordinator: self
        )
        let reviewsViewController = FilterReviewsViewController(viewModel: viewModel)
        self.navigationController.pushViewController(reviewsViewController, animated: true)
    }
    
    public func popViewController() {
        self.navigationController.popViewController(animated: true)
    }
}
