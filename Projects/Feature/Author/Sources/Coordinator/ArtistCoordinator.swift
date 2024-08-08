//
//  ArtistCoordinator.swift
//  Author
//
//  Created by 이숭인 on 8/8/24.
//

import UIKit
import CoreCommonKit

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
}
