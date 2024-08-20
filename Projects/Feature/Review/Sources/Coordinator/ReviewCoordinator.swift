//
//  ReviewCoordinator.swift
//  Review
//
//  Created by 이숭인 on 8/9/24.
//

import UIKit
import CoreCommonKit
import CoreUIKit

public final class ReviewCoordinator: ReviewCoordinatorable {
    public var finishDelegate: CoordinatorFinishDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    
    private let reviewUsecase = ReviewUsecase(
        reviewService: ReviewService()
    )
    
    public var filterID: String = ""
    public var isDirectPostedReview: (reviewID: String, isDirectMove: Bool) = ("", false)
    
    public var type: CoordinatorType { .review }
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    public func start() {
        if isDirectPostedReview.isDirectMove {
            presentWrittenReviewViewController(with: isDirectPostedReview.reviewID)
        } else {
            pushReviewCreateViewController()
        }
    }
    
    public func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
        
        self.navigationController.popViewController(animated: false)
    }
    
    private func pushReviewCreateViewController() {
        let viewModel = ReviewViewModel(
            coordinator: self,
            usecase: reviewUsecase,
            filterID: filterID
        )
        let reviewViewController = ReviewViewController(viewModel: viewModel)
        self.navigationController.setNavigationBarHidden(false, animated: false)
        
        self.navigationController.pushViewController(reviewViewController, animated: true)
    }
    
    public func presentCompleteAlert(with reviewID: String) {
        let stampViewController  = PurithmAnimateAlert<StampAnimateView>()
        stampViewController.modalPresentationStyle = .overCurrentContext
        
        self.navigationController.present(stampViewController, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            stampViewController.dismiss(animated: false)
            self?.navigationController.popViewController(animated: false)
            self?.presentWrittenReviewViewController(with: reviewID)
        }
    }
    
    public func presentWrittenReviewViewController(with reviewID: String) {
        let viewModel = PostedReviewViewModel(
            coordinator: self,
            usecase: reviewUsecase,
            reviewID: reviewID
        )
        
        let postedReviewController = PostedReviewController(viewModel: viewModel)
        self.navigationController.pushViewController(postedReviewController, animated: false)
    }
}
