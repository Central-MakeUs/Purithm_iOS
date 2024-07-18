//
//  TabBarCoordinator.swift
//  Purithm
//
//  Created by 이숭인 on 7/17/24.
//

import UIKit
import CoreCommonKit

protocol TabBarCoordinator: Coordinator {
    var tabBarController: UITabBarController { get set }
    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}
