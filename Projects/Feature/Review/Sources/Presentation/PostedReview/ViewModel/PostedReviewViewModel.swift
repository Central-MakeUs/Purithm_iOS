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
    }
}

final class PostedReviewViewModel {
    weak var coordinator: ReviewCoordinatorable?
    private let converter = PostedReviewSectionConverter()
    private var cancellables = Set<AnyCancellable>()
    
    private var reviewModel = CurrentValueSubject<FeedReviewModel, Never>(
        FeedReviewModel(
            identifier: UUID().uuidString,
            imageURLStrings: ["https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0"],
            author: "Hanna",
            authorProfileURL: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            satisfactionLevel: .high,
            content: "내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. "
        )
    )
    
    init(coordinator: ReviewCoordinatorable) {
        self.coordinator = coordinator
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
            .sink { _ in
                
            }
            .store(in: &cancellables)
    }
    
    private func handleAdapterItemTapEvent(input: Input, output: Output) {
        input.adapterActionEvent
            .sink { actionItem in
                switch actionItem {
                case let action as ReviewRemoveButtonAction:
                    print("ReviewRemoveButtonAction")
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
