//
//  FilterDetailReviewListViewModel.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import Foundation

final class FilterDetailReviewListViewModel {
    weak var coordinator: FiltersCoordinatorable?
    weak var filtersUsecase: FiltersUseCase?
    
    init(usecase: FiltersUseCase, coordinator: FiltersCoordinatorable) {
        self.coordinator = coordinator
        self.filtersUsecase = usecase
    }
}
