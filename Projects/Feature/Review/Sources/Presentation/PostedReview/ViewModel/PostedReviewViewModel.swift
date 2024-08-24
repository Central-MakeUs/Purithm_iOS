//
//  PostedReviewViewModel.swift
//  Review
//
//  Created by 이숭인 on 8/12/24.
//

import UIKit
import CoreUIKit
import Combine

extension PostedReviewViewModel {
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

final class PostedReviewViewModel {
    weak var coordinator: ReviewCoordinatorable?
    weak var usecase: ReviewUsecase?
    private let reviewID: String
    
    private let converter = PostedReviewSectionConverter()
    private var cancellables = Set<AnyCancellable>()
    
    private var reviewModel = CurrentValueSubject<FeedReviewModel?, Never>(nil)
    
    init(
        coordinator: ReviewCoordinatorable,
        usecase: ReviewUsecase,
        reviewID: String
    ) {
        self.coordinator = coordinator
        self.usecase = usecase
        self.reviewID = reviewID
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        bind(output: output)
        
        handleViewWillAppearEvent(input: input, output: output)
        handleAdapterItemTapEvent(input: input, output: output)
        
        return output
    }
    
    private func bind(output: Output) {
        reviewModel
            .compactMap { $0 }
            .sink { [weak self] review in
                guard let self else { return }
                let sections = self.converter.createSections(review: review)
                
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
    }
}

extension PostedReviewViewModel {
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                guard let reviewID = self?.reviewID else { return }
                
                self?.requestReviewLoad(with: reviewID)
            }
            .store(in: &cancellables)
    }
    
    private func handleAdapterItemTapEvent(input: Input, output: Output) {
        input.adapterActionEvent
            .sink { actionItem in
                switch actionItem {
                case _ as ReviewRemoveButtonAction:
                    output.conformAlertPresentEvent.send(Void())
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    func removeReview() {
        requestReviewRemove(with: reviewID)
    }
    
    func closeViewController() {
        coordinator?.finish()
    }
}

extension PostedReviewViewModel {
    private func requestReviewLoad(with reviewID: String) {
        usecase?.requestLoadReview(with: reviewID)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                var convertedResponse = response.convertModel()
                convertedResponse.identifier = reviewID
                
                self?.reviewModel.send(convertedResponse)
            })
            .store(in: &cancellables)
    }
    
    private func requestReviewRemove(with reviewID: String) {
        usecase?.requestRemoveReview(with: reviewID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
                self?.coordinator?.finish()
            })
            .store(in: &cancellables)
    }
}
