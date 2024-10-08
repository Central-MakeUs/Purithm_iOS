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
    func pushMyReviewsViewController()
    
    func pushFilterDetail(with filterID: String)
    func pushMyWishlistViewController()
    func pushFilterAccessHistoryViewController()
    func pushTotalStampViewModel()
    
    func pushCreateReviewViewController(with filterID: String)
    func pushPostedReviewViewController(with reviewID: String)
    func pushFilterOptionDetail(with filterID: String, filterName: String)
}
