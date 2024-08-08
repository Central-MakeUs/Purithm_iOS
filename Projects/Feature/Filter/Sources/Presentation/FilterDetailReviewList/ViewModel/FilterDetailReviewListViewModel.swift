//
//  FilterDetailReviewListViewModel.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import Foundation
import Combine
import CoreUIKit
import CoreCommonKit

extension FilterDetailReviewListViewModel {
    struct Input {
        
    }
    
    struct Output {
        fileprivate let sectionSubject = CurrentValueSubject<[SectionModelType], Never>([])
        var sections: AnyPublisher<[SectionModelType], Never> {
            sectionSubject.compactMap { $0 }.eraseToAnyPublisher()
        }
    }
}

final class FilterDetailReviewListViewModel {
    weak var coordinator: FilterDetailCoordinatorable?
    weak var filtersUsecase: FiltersUseCase?
    
    private let converter = FilterDetailReviewListSectionConverter()
    
    private var detailReviews: [FilterDetailReviewModel] = [
        FilterDetailReviewModel(
            identifier: UUID().uuidString,
            imageURLStrings: ["https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0"],
            author: "Hanna",
            authorProfileURL: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            satisfactionLevel: .high,
            content: "내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. "
        ),
        FilterDetailReviewModel(
            identifier: UUID().uuidString,
            imageURLStrings: ["https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0"],
            author: "Hanna",
            authorProfileURL: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            satisfactionLevel: .high,
            content: "내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. "
        ),
        FilterDetailReviewModel(
            identifier: UUID().uuidString,
            imageURLStrings: ["https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0"],
            author: "Hanna",
            authorProfileURL: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            satisfactionLevel: .high,
            content: "내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. "
        ),
        FilterDetailReviewModel(
            identifier: UUID().uuidString,
            imageURLStrings: ["https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0"],
            author: "Hanna",
            authorProfileURL: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            satisfactionLevel: .high,
            content: "내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. "
        ),
        FilterDetailReviewModel(
            identifier: UUID().uuidString,
            imageURLStrings: ["https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0"],
            author: "Hanna",
            authorProfileURL: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            satisfactionLevel: .high,
            content: "내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. "
        )
    ]
    
    init(usecase: FiltersUseCase, coordinator: FilterDetailCoordinatorable) {
        self.coordinator = coordinator
        self.filtersUsecase = usecase
    }
    
    func transform(intput: Input) -> Output {
        let output = Output()
        
        let sections = converter.createSections(with: detailReviews)
        output.sectionSubject.send(sections)
        
        return output
    }
}
