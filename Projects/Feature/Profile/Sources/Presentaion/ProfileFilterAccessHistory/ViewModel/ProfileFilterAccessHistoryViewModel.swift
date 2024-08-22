//
//  ProfileFilterAccessHistoryViewModel.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import Foundation
import Combine
import CoreCommonKit
import CoreUIKit
import UIKit

extension ProfileFilterAccessHistoryViewModel {
    struct Input {
        let viewWillAppearEvent: AnyPublisher<Bool, Never>
        let adapterActionEvent: AnyPublisher<ActionEventItem, Never>
    }
    
    struct Output {
        fileprivate let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
        var sections: AnyPublisher<[SectionModelType], Never> {
            sectionItems.eraseToAnyPublisher()
        }
        
        let conformAlertPresentEvent = PassthroughSubject<Void, Never>()
        
        fileprivate let sectionEmptySubject = PassthroughSubject<Bool, Never>()
        var sectionEmptyPublisher: AnyPublisher<Bool, Never> {
            sectionEmptySubject.eraseToAnyPublisher()
        }
    }
}

final class ProfileFilterAccessHistoryViewModel {
    weak var coordinator: ProfileCoordinatorable?
    weak var usecase: ProfileUsecase?
    
    private let converter = ProfileFilterAccessHistorySectionConverter()
    private var cancellables = Set<AnyCancellable>()
    
    private let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
    
    private var filterCards = CurrentValueSubject<[String: [ProfileFilterCardModel]], Never>([:])
    var sortedFilterCards: [String: [ProfileFilterCardModel]] {
        // DateFormatter 설정
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            // 정렬된 데이터를 저장할 딕셔너리
            var sortedDictionary: [String: [ProfileFilterCardModel]] = [:]
            
            // filterCards에 저장된 데이터를 정렬
            for (key, value) in filterCards.value {
                // 날짜 기준으로 정렬
                let sortedValues = value.sorted(by: { firstModel, secondModel in
                    guard let date1 = dateFormatter.date(from: firstModel.createdAt),
                          let date2 = dateFormatter.date(from: secondModel.createdAt) else {
                        return false
                    }
                    return date1 > date2 // 내림차순
                })
                sortedDictionary[key] = sortedValues
            }
        return sortedDictionary
    }
    
    init(coordinator: ProfileCoordinatorable, usecase: ProfileUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        bind(output: output)
        
        handleViewWillAppearEvent(input: input, output: output)
        handleAdapterActionEvent(input: input, output: output)
        
        return output
    }
    
    private func bind(output: Output) {
        sectionItems
            .sink { sections in
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
        
        filterCards
            .filter { !$0.isEmpty}
            .sink { [weak self] cards in
                guard let self else { return }
                
                let sections = self.converter.createSections(
                    cards: self.sortedFilterCards
                )
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
    }
}

//MARK: - Handle View Will Appear Event
extension ProfileFilterAccessHistoryViewModel {
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                self?.requestFilterAccessHistory()
            }
            .store(in: &cancellables)
    }
}

//MARK: Handle Action Event
extension ProfileFilterAccessHistoryViewModel {
    private func handleAdapterActionEvent(input: Input, output: Output) {
        input.adapterActionEvent
            .sink { [weak self] actionItem in
                guard let self else { return }
                switch actionItem {
                case let action as ProfileCardReviewAction:
                    print("리뷰로 이동")
                case let action as ProfileCardFilterAction:
                    print("필터값 보기로 이동")
                case let action as ProfileCardImageAction:
                    print("필터 상세")
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - API Request
extension ProfileFilterAccessHistoryViewModel {
    private func requestFilterAccessHistory() {
        usecase?.requestFilterAccessHistory()
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                var cardDict: [String: [ProfileFilterCardModel]] = [:]
                
                response.list.forEach { history in
                    let cardModels = history.filters.map { filter in
                        ProfileFilterCardModel(
                            filterId: "\(filter.filterId)",
                            filterName: filter.filterName,
                            author: filter.photographer,
                            hasReview: filter.hasReview,
                            reviewId: "\(filter.reviewId)",
                            planType: PlanType.calculatePlanType(with: filter.membership),
                            createdAt: filter.createdAt
                        )
                    }
                    
                    cardDict[history.date] = cardModels
                }
                
                self?.filterCards.send(cardDict)
            })
            .store(in: &cancellables)
    }
}
