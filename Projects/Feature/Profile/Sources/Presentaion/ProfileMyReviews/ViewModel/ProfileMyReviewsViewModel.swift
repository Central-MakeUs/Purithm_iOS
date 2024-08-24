//
//  ProfileMyReviewsViewModel.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import Foundation
import Combine
import CoreCommonKit
import CoreUIKit
import UIKit

extension ProfileMyReviewsViewModel {
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
    }
}

final class ProfileMyReviewsViewModel {
    weak var coordinator: ProfileCoordinatorable?
    weak var usecase: ProfileUsecase?
    
    private let converter = ProfileMyReviewsSectionConverter()
    private var cancellables = Set<AnyCancellable>()
    
    private let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
    
    private var filterInformations = CurrentValueSubject<[(name: String, thumbnail: String)], Never>([])
    private var reviewsModels = CurrentValueSubject<[FeedReviewModel], Never>([])
    var reviews: AnyPublisher<[FeedReviewModel], Never> {
        reviewsModels.eraseToAnyPublisher()
    }
    
    private var reviewID: String = ""
    
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
        reviewsModels
            .sink { [weak self] reviews in
                guard let self  else { return }
                let sections = self.converter.createSections(
                    with: self.reviewsModels.value,
                    filterInfo: self.filterInformations.value
                )
                
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
    }
    
    func removeReview() {
        requestReviewRemove(with: reviewID)
    }
}

//MARK: - Handle View Will Appear Event
extension ProfileMyReviewsViewModel {
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                self?.requestMyReviews()
            }
            .store(in: &cancellables)
    }
}

//MARK: Handle Action Event
extension ProfileMyReviewsViewModel {
    private func handleAdapterActionEvent(input: Input, output: Output) {
        input.adapterActionEvent
            .sink { [weak self] actionItem in
                switch actionItem {
                case let action as FeedToDetailMoveAction:
                    let filterID = action.identifier
                    self?.coordinator?.pushFilterDetail(with: filterID)
                case let action as ReviewRemoveButtonAction:
                    let reviewID = action.identifier
                    self?.reviewID = reviewID
                    output.conformAlertPresentEvent.send(())
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - API Request
extension ProfileMyReviewsViewModel {
    private func requestMyReviews() {
        usecase?.requestMyReviews()
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                let convertedResponse = response.map { $0.convertModel() }
                let informations = response.map { $0.retriveFilterInformation() }
                
                self?.filterInformations.send(informations)
                self?.reviewsModels.send(convertedResponse)
            })
            .store(in: &cancellables)
    }
    
    private func requestReviewRemove(with reviewID: String) {
        usecase?.requestRemoveReview(with: reviewID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
                self?.requestMyReviews()
            })
            .store(in: &cancellables)
    }
}
