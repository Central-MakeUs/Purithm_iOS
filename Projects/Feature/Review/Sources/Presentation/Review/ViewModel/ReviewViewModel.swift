//
//  ReviewViewModel.swift
//  Review
//
//  Created by 이숭인 on 8/9/24.
//

import Foundation

public final class ReviewViewModel {
    weak var coordinator: ReviewCoordinatorable?
    
    public init(coordinator: ReviewCoordinatorable) {
        self.coordinator = coordinator
    }
}
