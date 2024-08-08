//
//  FiltersCoordinatorable.swift
//  Filter
//
//  Created by 이숭인 on 7/30/24.
//

import Foundation
import CoreCommonKit

public protocol FiltersCoordinatorable: Coordinator {
    func pushFilterDetail(with filterID: String)
}
