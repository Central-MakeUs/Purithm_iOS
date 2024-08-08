//
//  FilterReviewsViewModel.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import Foundation
import CoreUIKit
import Combine
import CombineExt
import CoreCommonKit

extension FilterReviewsViewModel {
    struct Input {
        let itemSelectEvent: AnyPublisher<ItemModelType, Never>
        let conformTapEvent: AnyPublisher<Void, Never>
    }
    
    struct Output {
        fileprivate let sectionsSubject = CurrentValueSubject<[SectionModelType], Never>([])
        var sections: AnyPublisher<[SectionModelType], Never> {
            sectionsSubject.compactMap { $0 }.eraseToAnyPublisher()
        }
    }
}

final class FilterReviewsViewModel {
    weak var coordinator: FilterDetailCoordinatorable?
    weak var filtersUsecase: FiltersUseCase?
    private var cancellables = Set<AnyCancellable>()
    
    private let converter = FilterReviewsSectionConverter()
    
    private var reviewTotalCount = 100
    private var satisfactionModel = FilterSatisfactionModel(
        identifier: UUID().uuidString,
        satisfactionLevel: .veryHigh
    )
    private var reviews: [FilterReviewItemModel] = [
        FilterReviewItemModel(
            identifier: UUID().uuidString,
            thumbnailImageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            author: "Hanna",
            date: "2024.07.09",
            satisfactionLevel: .veryHigh
        ),
        FilterReviewItemModel(
            identifier: UUID().uuidString,
            thumbnailImageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            author: "Hanna",
            date: "2024.07.09",
            satisfactionLevel: .high
        ),
        FilterReviewItemModel(
            identifier: UUID().uuidString,
            thumbnailImageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            author: "Hanna",
            date: "2024.07.09",
            satisfactionLevel: .mediumHigh
        ),
        FilterReviewItemModel(
            identifier: UUID().uuidString,
            thumbnailImageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            author: "Hanna",
            date: "2024.07.09",
            satisfactionLevel: .medium
        ),
        FilterReviewItemModel(
            identifier: UUID().uuidString,
            thumbnailImageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            author: "Hanna",
            date: "2024.07.09",
            satisfactionLevel: .low
        ),
        FilterReviewItemModel(
            identifier: UUID().uuidString,
            thumbnailImageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            author: "Hanna",
            date: "2024.07.09",
            satisfactionLevel: .low
        ),
        FilterReviewItemModel(
            identifier: UUID().uuidString,
            thumbnailImageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            author: "Hanna",
            date: "2024.07.09",
            satisfactionLevel: .low
        ),
        FilterReviewItemModel(
            identifier: UUID().uuidString,
            thumbnailImageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            author: "Hanna",
            date: "2024.07.09",
            satisfactionLevel: .low
        )
    ]
    
    init(with filterID: String, usecase: FiltersUseCase, coordinator: FilterDetailCoordinatorable) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        let sections = converter.createSections(
            satisfaction: satisfactionModel,
            reviews: reviews,
            reviewCount: reviewTotalCount
        )
        
        output.sectionsSubject.send(sections)
        
        input.itemSelectEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] itemModel in
                self?.coordinator?.pushFilterReviewDetailList()
            }
            .store(in: &cancellables)
        
        input.conformTapEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.coordinator?.pushReviewViewController()
            }
            .store(in: &cancellables)
        
        return output
    }
}
