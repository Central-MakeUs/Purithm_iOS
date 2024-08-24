//
//  FiltersDetailCoordinator.swift
//  Filter
//
//  Created by 이숭인 on 8/8/24.
//

import UIKit
import CoreCommonKit
import CoreUIKit
import Review

public final class FilterDetailCoordinator: FilterDetailCoordinatorable {
    public var finishDelegate: CoordinatorFinishDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .filterDetail }
    public var filterID: String = ""
    
    private let filtersUseCase = FiltersUseCase(
        filterService: FilterService()
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
        showFilterDetailFlow()
    }
    
    private func showFilterDetailFlow() {
        let viewModel = FilterDetailViewModel(
            with: filterID,
            coordinator: self,
            usecase: filtersUseCase
        )
        let filterDetailViewController = FilterDetailViewController(viewModel: viewModel)
        filterDetailViewController.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(filterDetailViewController, animated: true)
    }
    
    public func pushFilterOptionDetail(with filterID: String, filterName: String) {
        let viewModel = FilterOptionDetailViewModel(
            coordinator: self,
            filtersUsecase: filtersUseCase,
            filterID: filterID
        )
        let optionDetailViewController = FilterOptionDetailViewController(viewModel: viewModel)
        
        let waitViewController = PurithmAnimateAlert<FilterWaitAnimateView>()
        waitViewController.contentView.configure(with: filterName)
        waitViewController.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(waitViewController, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            waitViewController.dismiss(animated: false)
            self?.navigationController.pushViewController(optionDetailViewController, animated: false)
        }
    }
    
    public func pushFilterReviewDetailList(with reviewID: String, filterID: String) {
        let viewModel = FilterDetailReviewListViewModel(
            usecase: filtersUseCase,
            coordinator: self, 
            filterID: filterID,
            reviewID: reviewID
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
    
    public func moveToFilterDetailFromFilterReviews(with filterName: String) {
        self.popViewController(animated: false)
        pushFilterOptionDetail(with: filterID, filterName: filterName)
    }
    
    public func popViewController(animated: Bool) {
        self.navigationController.popViewController(animated: animated)
    }
}

//MARK: - Move To Review Module VC
extension FilterDetailCoordinator {
    public func pushReviewViewController() {
        let coordinator = ReviewCoordinator(self.navigationController)
        coordinator.finishDelegate = self
        coordinator.filterID = filterID
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    public func pushPostedReviewViewController(with reviewID: String) {
        let coordinator = ReviewCoordinator(self.navigationController)
        coordinator.finishDelegate = self
        coordinator.isDirectPostedReview = (reviewID, true)
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
}

//MARK: - Finish Delegate
extension FilterDetailCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
    }
}
