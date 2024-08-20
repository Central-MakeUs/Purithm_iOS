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
        let viewWillAppearEvent: AnyPublisher<Bool, Never>
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
    
    private var cancellables = Set<AnyCancellable>()
    private var filterID: String
    private var reviewID: String
    
    private let converter = FilterDetailReviewListSectionConverter()
    
    private var detailReviewsSubject = CurrentValueSubject<[FeedReviewModel], Never>([])
    var willMoveItemIndexPath = PassthroughSubject<IndexPath, Never>()
    
    init(usecase: FiltersUseCase,
         coordinator: FilterDetailCoordinatorable,
         filterID: String,
         reviewID: String) {
        self.coordinator = coordinator
        self.filtersUsecase = usecase
        self.filterID = filterID
        self.reviewID = reviewID
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                self?.requestReviews(filterID: self?.filterID ?? "")
            }
            .store(in: &cancellables)
        
        detailReviewsSubject
            .sink { [weak self] reviews in
                let sections = self?.converter.createSections(with: reviews) ?? []
                output.sectionSubject.send(sections)
                
                if let targetIndex = reviews.firstIndex(where: { $0.identifier == (self?.reviewID ?? "") }) {
                    let indexPath = IndexPath(row: targetIndex, section: 0)
                    self?.willMoveItemIndexPath.send(indexPath)
                }
            }
            .store(in: &cancellables)
        
        return output
    }
}

extension FilterDetailReviewListViewModel {
    private func requestReviews(filterID: String) {
        filtersUsecase?.requestReviewsFromFilter(with: filterID)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                let reviewModels = response.convertReviewModel()
                self?.detailReviewsSubject.send(reviewModels)
            })
            .store(in: &cancellables)
    }
}
