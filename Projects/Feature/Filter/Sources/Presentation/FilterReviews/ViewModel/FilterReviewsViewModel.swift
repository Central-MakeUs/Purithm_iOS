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

extension FilterReviewsViewModel {
    struct Input {
        let itemSelectEvent: AnyPublisher<ItemModelType, Never>
    }
    
    struct Output {
        fileprivate let sectionsSubject = CurrentValueSubject<[SectionModelType], Never>([])
        var sections: AnyPublisher<[SectionModelType], Never> {
            sectionsSubject.compactMap { $0 }.eraseToAnyPublisher()
        }
    }
}

final class FilterReviewsViewModel {
    weak var coordinator: FiltersCoordinatorable?
    weak var filtersUsecase: FiltersUseCase?
    private var cancellables = Set<AnyCancellable>()
    
    private let converter = FilterReviewsSectionConverter()
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
    
    init(with filterID: String, usecase: FiltersUseCase, coordinator: FiltersCoordinatorable) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        let sections = converter.createSections(
            satisfaction: satisfactionModel,
            reviews: reviews
        )
        
        output.sectionsSubject.send(sections)
        
        input.itemSelectEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] itemModel in
                self?.coordinator?.pushFilterReviewDetailList()
            }
            .store(in: &cancellables)
        
        return output
    }
}

//TODO:
/*
 오늘 후기 상세까지 다 끝내자. + 바텀시트
 */
