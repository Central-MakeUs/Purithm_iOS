//
//  CoordinatorFinishDelegate.swift
//  CoreCommonKit
//
//  Created by 이숭인 on 7/17/24.
//

import Foundation

public protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
