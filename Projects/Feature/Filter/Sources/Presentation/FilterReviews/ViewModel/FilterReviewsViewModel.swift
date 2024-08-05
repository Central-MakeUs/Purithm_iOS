//
//  FilterReviewsViewModel.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import Foundation

final class FilterReviewsViewModel {
    weak var coordinator: FiltersCoordinatorable?
    weak var filtersUsecase: FiltersUseCase?
    
    init(with filterID: String, usecase: FiltersUseCase, coordinator: FiltersCoordinatorable) {
        self.coordinator = coordinator
    }
}
