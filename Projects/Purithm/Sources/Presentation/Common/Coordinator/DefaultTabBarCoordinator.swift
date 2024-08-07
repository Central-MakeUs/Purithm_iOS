//
//  DefaultTabBarCoordinator.swift
//  Purithm
//
//  Created by 이숭인 on 7/17/24.
//

import UIKit
import CoreCommonKit

import Filter

final class DefaultTabBarCoordinator: TabBarCoordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var tabBarController: UITabBarController
    var type: CoordinatorType { .tab }
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let pages: [TabBarPage] = TabBarPage.allCases
        let controllers: [UINavigationController] = pages.map {
            self.createTabNavigationController(of: $0)
        }
        self.configureTabBarController(with: controllers)
    }

    
    func selectPage(_ page: TabBarPage) {
        self.tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage(index: index) else { return }
        self.tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func currentPage() -> TabBarPage? {
        TabBarPage(index: self.tabBarController.selectedIndex)
    }
}

extension DefaultTabBarCoordinator {
    private func configureTabBarItem(of page: TabBarPage) -> UITabBarItem {
        let tabbarItem = UITabBarItem(
            title: nil,
            image: page.tabIcon(),
            tag: page.pageOrderNumber()
        )
        tabbarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        
        return tabbarItem
    }
    
    private func createTabNavigationController(of page: TabBarPage) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        
        tabNavigationController.setNavigationBarHidden(false, animated: false)
        tabNavigationController.tabBarItem = self.configureTabBarItem(of: page)
        self.startTabCoordinator(of: page, to: tabNavigationController)
        return tabNavigationController
    }
    
    private func configureTabBarController(with tabViewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(tabViewControllers, animated: true)
        self.tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        self.tabBarController.view.backgroundColor = .white
        self.tabBarController.tabBar.backgroundColor = .white
        self.tabBarController.tabBar.tintColor = .blue400
        
        self.navigationController.pushViewController(self.tabBarController, animated: true)
    }
    
    private func startTabCoordinator(of page: TabBarPage, to tabNavigationController: UINavigationController) {
        switch page {
        case .home:
            let filtersCoordinator = FiltersCoordinator(tabNavigationController)
            self.childCoordinators.append(filtersCoordinator)
            filtersCoordinator.start()
        case .author:
            // TODO: 각 피처별 코디네이터 할당 필요함.
            let authorVC = UIViewController()
            authorVC.view.backgroundColor = .green
            tabNavigationController.viewControllers = [authorVC]
        case .collector:
            let collectorVC = UIViewController()
            collectorVC.view.backgroundColor = .blue400
            tabNavigationController.viewControllers = [collectorVC]
        case .mypage:
            let mypageVC = UIViewController()
            mypageVC.view.backgroundColor = .purple400
            tabNavigationController.viewControllers = [mypageVC]
        }
    }
}

extension DefaultTabBarCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) { }
}
