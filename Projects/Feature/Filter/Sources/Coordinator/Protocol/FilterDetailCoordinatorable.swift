//
//  FiltersDetailCoordinatorable.swift
//  Filter
//
//  Created by 이숭인 on 8/8/24.
//

import Foundation
import CoreCommonKit

public protocol FilterDetailCoordinatorable: Coordinator {
    func pushFilterOptionDetail(with filterID: String, filterName: String)
    func pushFilterReviewDetailList(with reviewID: String, filterID: String)
    func pushFilterReviews(with filterID: String)
    func pushFilterDescription(with filterID: String)
    func popViewController(animated: Bool)
    
    func pushReviewViewController()
}
