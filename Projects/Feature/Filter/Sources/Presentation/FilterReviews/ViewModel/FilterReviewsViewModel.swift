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
    private enum Constants {
        static let satisfactionIdentifier = "satisfaction_item_identifier"
    }
}

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
        
        fileprivate let filterRecordForMeSubject = PassthroughSubject<FilterRecordForMeModel, Never>()
        var filterRecordForMePublisher: AnyPublisher<FilterRecordForMeModel, Never> {
            filterRecordForMeSubject.eraseToAnyPublisher()
        }
    }
}

final class FilterReviewsViewModel {
    weak var coordinator: FilterDetailCoordinatorable?
    weak var filtersUsecase: FiltersUseCase?
    private var cancellables = Set<AnyCancellable>()
    
    private let converter = FilterReviewsSectionConverter()
    
    private let filterID: String
    private var reviewTotalCount = 0
    private var satisfactionModel: FilterSatisfactionModel?
    
    private var reviews = CurrentValueSubject<[FilterReviewItemModel], Never>([])
    private var filterRecordForMe = CurrentValueSubject<FilterRecordForMeModel?, Never>(nil)
    private var filterDetail = CurrentValueSubject<FilterDetailModel?, Never>(nil)
    var filter: FilterDetailModel? {
        filterDetail.value
    }
    
    init(with filterID: String, usecase: FiltersUseCase, coordinator: FilterDetailCoordinatorable) {
        self.filterID = filterID
        self.coordinator = coordinator
        self.filtersUsecase = usecase
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        bind(output: output)
        
        handleViewWillAppearEvent(input: input, output: output)
        handleDidSelectEvent(input: input, output: output)
        handleBottomButtonTapEvent(input: input, output: output)
        
        return output
    }
    
    private func bind(output: Output) {
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
        
        filterRecordForMe
            .compactMap { $0 }
            .sink { recordModel in
                output.filterRecordForMeSubject.send(recordModel)
            }
            .store(in: &cancellables)
    }
}

//MARK: - Handle ViewWillAppear
extension FilterReviewsViewModel {
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                let filterID = self?.filterID ?? ""
                self?.requestReviewsFromFilter(with: filterID)
                self?.requestFilterDetailInfomation(with: filterID)
            }
            .store(in: &cancellables)
    }
}

//MARK: - Handle Did Select Event
extension FilterReviewsViewModel {
    private func handleDidSelectEvent(input: Input, output: Output) {
        input.itemSelectEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] itemModel in
                guard itemModel.identifier != Constants.satisfactionIdentifier else {
                    return
                }
                
                let reviewID = itemModel.identifier
                self?.coordinator?.pushFilterReviewDetailList(
                    with: reviewID,
                    filterID: self?.filterID ?? ""
                )
            }
            .store(in: &cancellables)
    }
}

//MARK: - Handle Bottom Button Tap Event
extension FilterReviewsViewModel {
    private func handleBottomButtonTapEvent(input: Input, output: Output) {
        input.conformTapEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self,
                      let recordModel = self.filterRecordForMe.value else {
                    return
                }
                
                if recordModel.hasReview && !recordModel.myReviewID.isEmpty {
                    //  내가 남긴 후기 조회
                    let reviewID = self.filterRecordForMe.value?.myReviewID ?? ""
                    self.coordinator?.pushPostedReviewViewController(with: reviewID)
                } else if recordModel.hasViewd {
                    // 후기 작성화면 이동
                     self.coordinator?.pushReviewViewController()
                } else if !recordModel.hasViewd {
                    // 필터값 보기로 이동
                    let filterName = filter?.detailInformation.title ?? ""
                    self.coordinator?.moveToFilterDetailFromFilterReviews(with: filterName)
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - API Request
extension FilterReviewsViewModel {
    private func requestReviewsFromFilter(with filterID: String) {
        filtersUsecase?.requestReviewsFromFilter(with: filterID)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                // 1. 평균 만족도 설정
                let satisfactionLevel = SatisfactionLevel.calculateSatisfactionLevel(with: response.avg)
                let satisfaction = FilterSatisfactionModel(
                    identifier: Constants.satisfactionIdentifier,
                    satisfactionLevel: satisfactionLevel,
                    averageValue: response.avg
                )
                self?.satisfactionModel = satisfaction
                
                // 2. 필터에 대한 내 기록 정보 설정
                let reviewID = response.reviewId == .zero ? "" : "\(response.reviewId)"
                let recordModel =  FilterRecordForMeModel(
                    hasViewd: response.hasViewed,
                    hasReview: response.hasReview,
                    myReviewID: reviewID
                )
                self?.filterRecordForMe.send(recordModel)
                
                // 3. 총 갯수 설정
                self?.reviewTotalCount = response.reviews.count
                
                // 4. 리뷰 리스트 설정
                let reviewItems = response.convertReviewItemModel()
                self?.reviews.send(reviewItems)
            })
            .store(in: &cancellables)
    }
    
    private func requestFilterDetailInfomation(with filterID: String) {
        filtersUsecase?.requestFilterDetail(with: filterID)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] detailResponse in
                let detailModel = detailResponse.convertModel()
                self?.filterDetail.send(detailModel)
            })
            .store(in: &cancellables)
    }
}
