//
//  ReviewCoordinatorable.swift
//  Review
//
//  Created by 이숭인 on 8/9/24.
//

import Foundation
import CoreCommonKit

public protocol ReviewCoordinatorable: Coordinator {
    func presentCompleteAlert(with reviewID: String)
    func presentWrittenReviewViewController(with reviewID: String)
}
