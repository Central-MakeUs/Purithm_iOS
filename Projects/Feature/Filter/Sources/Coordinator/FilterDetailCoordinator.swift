//
//  FiltersDetailCoordinator.swift
//  Filter
//
//  Created by 이숭인 on 8/8/24.
//

import UIKit
import CoreCommonKit

public final class FilterDetailCoordinator: FilterDetailCoordinatorable {
    public var finishDelegate: CoordinatorFinishDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .filterDetail }
    
    private let filtersUseCase = FiltersUseCase(
        authService: FiltersService()
    )
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    deinit {
        print("::: FiltersDetailCoordinator")
    }
    
    public func finish() {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    public func start() {
        //TODO: filterID 주입받아야함
        let viewModel = FilterDetailViewModel(with: "", coordinator: self)
        let filterDetailViewController = FilterDetailViewController(viewModel: viewModel)
        filterDetailViewController.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(filterDetailViewController, animated: true)
    }
    
    public func pushFilterOptionDetail(with filterID: String) {
        let viewModel = FilterOptionDetailViewModel(
            coordinator: self,
            filtersUsecase: filtersUseCase
        )
        let optionDetailViewController = FilterOptionDetailViewController(viewModel: viewModel)
        self.navigationController.pushViewController(optionDetailViewController, animated: false)
    }
    
    public func pushFilterReviewDetailList() {
        let viewModel = FilterDetailReviewListViewModel(
            usecase: filtersUseCase,
            coordinator: self
        )
        let detailReviewListViewController = FilterDetailReviewListViewController(viewModel: viewModel)
        self.navigationController.pushViewController(detailReviewListViewController, animated: true)
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
    
    public func pushFilterDescription(with filterID: String) {
        let viewModel = FilterDescriptionViewModel(
            filterID: filterID,
            useCase: filtersUseCase
        )
        let filterDescriptionViewController = FilterDescriptionViewController(viewModel: viewModel)
        self.navigationController.pushViewController(filterDescriptionViewController, animated: true)
    }
    
    public func popViewController(animated: Bool) {
        self.navigationController.popViewController(animated: animated)
    }
}
