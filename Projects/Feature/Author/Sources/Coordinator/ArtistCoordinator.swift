//
//  ArtistCoordinator.swift
//  Author
//
//  Created by 이숭인 on 8/8/24.
//

import UIKit
import CoreCommonKit
import Filter

public final class ArtistCoordinator: ArtistCoordinatorable {
    public var finishDelegate: CoordinatorFinishDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .filters }
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    public func start() {
        let viewModel = ArtistsViewModel(coordinator: self)
        let artistsViewController = ArtistsViewController(viewModel: viewModel)
        
        self.navigationController.viewControllers = [artistsViewController]
    }
    
    public func pushArtistDetail(with artistID: String) {
        let viewModel = ArtistDetailViewModel(coordinator: self)
        let detailViewController = ArtistDetailViewController(viewModel: viewModel)
        
        self.navigationController.pushViewController(detailViewController, animated: true)
    }
    
    public func pushFilterDetail(with filterID: String) {
        let coordinator = FilterDetailCoordinator(self.navigationController)
        coordinator.finishDelegate = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension ArtistCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
    }
}
