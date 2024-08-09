//
//  ReviewViewModel.swift
//  Review
//
//  Created by 이숭인 on 8/9/24.
//

import Foundation
import Combine
import CoreUIKit

extension ReviewViewModel {
    struct Input {
        let viewWillAppearEvent: AnyPublisher<Bool, Never>
    }
    
    struct Output {
        fileprivate let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
        var sections: AnyPublisher<[SectionModelType], Never> {
            sectionItems.eraseToAnyPublisher()
        }
    }
}

public final class ReviewViewModel {
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: ReviewCoordinatorable?
    private let converter = ReviewSectionConverter()
    
    private var headerModel = CurrentValueSubject<ReviewHeaderComponentModel?, Never>(nil)
    
    public init(coordinator: ReviewCoordinatorable) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        bind(output: output)
        
        handleViewWillAppearEvent(input: input, output: output)
        
        return output
    }
    
    private func bind(output: Output) {
        headerModel
            .compactMap { $0 }
            .sink { [weak self] model in
                guard let self else { return }
                
                let sections = self.converter.createSections(headerModel: model)
                
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
    }
    
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                self?.setupHeader()
            }
            .store(in: &cancellables)
    }
    
    private func setupHeader() {
        let model = ReviewHeaderComponentModel(
            identifier: UUID().uuidString,
            title: "How Purithm",
            description: "아래 바를 조절해 만족도를 남겨주세요.",
            thumbnailURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            satisfactionLevel: .low
        )
        
        headerModel.send(model)
    }
}
