//
//  FeedsCoordinatorable.swift
//  Feed
//
//  Created by 이숭인 on 8/8/24.
//

import Foundation
import CoreCommonKit

public protocol FeedsCoordinatorable: Coordinator {
    func pushFilterDetail(with filterID: String)
}
