//
//  ProfileCoordinatorable.swift
//  Profile
//
//  Created by 이숭인 on 8/19/24.
//

import Foundation
import CoreCommonKit

public protocol ProfileCoordinatorable: Coordinator {
    func pushProfileSettingViewContriller()
    func pushAccountInfomationViewController()
    func pushProfileEditViewController()
}
