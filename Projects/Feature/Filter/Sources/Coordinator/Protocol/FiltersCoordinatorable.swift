//
//  FiltersCoordinatorable.swift
//  Filter
//
//  Created by 이숭인 on 7/30/24.
//

import Foundation
import CoreCommonKit

public protocol FiltersCoordinatorable: Coordinator {
    func pushFilterReviewDetailList()
    func pushFilterReviews(with filterID: String)
    func pushFilterDescription(with filterID: String)
    func pushFilterDetail(with filterID: String)
    func popViewController()
}
