//
//  LoginCoordinator.swift
//  Login
//
//  Created by 이숭인 on 7/17/24.
//

import CoreCommonKit

public protocol LoginCoordinatorable: Coordinator {
    func pushLoginViewController()
    func pushTermsViewController()
    func testLogin()
    func presentWelcomeAlert()
}
