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
    
    public func pushFilterDetail(with filterID: String) {
        let filterDetailCoordinator = FilterDetailCoordinator(self.navigationController)
        filterDetailCoordinator.finishDelegate = self
        self.childCoordinators.append(filterDetailCoordinator)
        filterDetailCoordinator.start()
    }
}

extension FiltersCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
    }
}
