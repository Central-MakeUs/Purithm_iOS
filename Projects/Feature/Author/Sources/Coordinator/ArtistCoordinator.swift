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
    
    private let artistUsecase = AuthorUsecase(authorService: AuthorService())
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    public func start() {
        let viewModel = ArtistsViewModel(
            coordinator: self,
            usecase: artistUsecase
        )
        let artistsViewController = ArtistsViewController(viewModel: viewModel)
        
        self.navigationController.viewControllers = [artistsViewController]
    }
    
    public func pushArtistDetail(with artistID: String) {
        let viewModel = ArtistDetailViewModel(
            coordinator: self,
            usecase: artistUsecase,
            authorID: artistID
        )
        let detailViewController = ArtistDetailViewController(viewModel: viewModel)
        
        self.navigationController.pushViewController(detailViewController, animated: true)
    }
    
    public func pushFilterDetail(with filterID: String) {
        let coordinator = FilterDetailCoordinator(self.navigationController)
        coordinator.finishDelegate = self
        coordinator.filterID = filterID
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension ArtistCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
    }
}
