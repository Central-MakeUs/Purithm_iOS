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
        let viewWillAppearEvent: AnyPublisher<Bool, Never>
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
    
    private let filterID: String
    
    private var reviewTotalCount = 100
    
    private var satisfactionModel: FilterSatisfactionModel?
    
    private var reviews = CurrentValueSubject<[FilterReviewItemModel], Never>([])
    
    init(with filterID: String, usecase: FiltersUseCase, coordinator: FilterDetailCoordinatorable) {
        self.filterID = filterID
        self.coordinator = coordinator
        self.filtersUsecase = usecase
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        reviews
            .sink { [weak self] reviews in
                guard let self,
                      let satisfactionModel = self.satisfactionModel else { return }
                
                let sections = self.converter.createSections(
                    satisfaction: satisfactionModel,
                    reviews: reviews,
                    reviewCount: self.reviewTotalCount
                )
                
                output.sectionsSubject.send(sections)
            }
            .store(in: &cancellables)
        
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                self?.requestReviewsFromFilter(with: self?.filterID ?? "")
            }
            .store(in: &cancellables)
        
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

//MARK: - API Request
extension FilterReviewsViewModel {
    private func requestReviewsFromFilter(with filterID: String) {
        filtersUsecase?.requestReviewsFromFilter(with: filterID)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                // 평균 만족도 설정
                let satisfactionLevel = self?.calculateSatisfactionLevel(with: response.avg)
              
                let satisfaction = FilterSatisfactionModel(
                    identifier: UUID().uuidString,
                    satisfactionLevel: satisfactionLevel ?? .none,
                    averageValue: response.avg
                )
                self?.satisfactionModel = satisfaction
                
                // 리뷰 리스트 설정
                let reviewItems = response.convertModel()
                self?.reviews.send(reviewItems)
            })
            .store(in: &cancellables)
    }
    
    private func calculateSatisfactionLevel(with averageValue: Int) -> SatisfactionLevel {
        switch averageValue {
        case 20...30:
            return SatisfactionLevel.low
        case 31...50:
            return SatisfactionLevel.medium
        case 51...70:
            return SatisfactionLevel.mediumHigh
        case 71...90:
            return SatisfactionLevel.high
        case 91...100:
            return SatisfactionLevel.veryHigh
        default:
            return SatisfactionLevel.none
        }
    }
}
