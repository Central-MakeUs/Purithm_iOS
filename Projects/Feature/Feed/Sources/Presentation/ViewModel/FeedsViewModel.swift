//
//  FeedsViewModel.swift
//  Feed
//
//  Created by 이숭인 on 8/8/24.
//

import Foundation
import Combine
import CoreCommonKit
import CoreUIKit

extension FeedsViewModel {
    struct Input {
        let viewWillAppearEvent: AnyPublisher<Bool, Never>
        let adapterActionEvent: AnyPublisher<ActionEventItem, Never>
    }
    
    struct Output {
        fileprivate let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
        var sections: AnyPublisher<[SectionModelType], Never> {
            sectionItems.eraseToAnyPublisher()
        }
        
        fileprivate let presentOrderOptionBottomSheetEventSubject = PassthroughSubject<Void, Never>()
        var presentOrderOptionBottomSheetEvent: AnyPublisher<Void, Never> {
            presentOrderOptionBottomSheetEventSubject.eraseToAnyPublisher()
        }
    }
}

final class FeedsViewModel {
    weak var coordinator: FeedsCoordinatorable?
    var cancellables = Set<AnyCancellable>()
    let converter = FeedsSectionConverter()
    
    private var orderOptionModels = CurrentValueSubject<[FeedOrderOptionModel], Never>([])
    private var selectedOrderOption: FeedOrderOptionModel? {
        orderOptionModels.value.filter { $0.isSelected }.first
    }
    var orderOptions: [FeedOrderOptionModel] {
        orderOptionModels.value
    }
    
    private var reviewsModels = CurrentValueSubject<[FeedReviewModel], Never>([
        FeedReviewModel(
            identifier: UUID().uuidString,
            imageURLStrings: ["https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0"],
            author: "Hanna",
            authorProfileURL: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            satisfactionLevel: .high,
            content: "내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. "
        ),
        FeedReviewModel(
            identifier: UUID().uuidString,
            imageURLStrings: ["https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0"],
            author: "Hanna",
            authorProfileURL: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            satisfactionLevel: .high,
            content: "내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. "
        ),
        FeedReviewModel(
            identifier: UUID().uuidString,
            imageURLStrings: ["https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0"],
            author: "Hanna",
            authorProfileURL: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            satisfactionLevel: .high,
            content: "내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. "
        ),
        FeedReviewModel(
            identifier: UUID().uuidString,
            imageURLStrings: ["https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0"],
            author: "Hanna",
            authorProfileURL: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            satisfactionLevel: .high,
            content: "내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. "
        ),
        FeedReviewModel(
            identifier: UUID().uuidString,
            imageURLStrings: ["https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0"],
            author: "Hanna",
            authorProfileURL: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            satisfactionLevel: .high,
            content: "내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. 내용입니다. "
        )
    ])
    var reviews: AnyPublisher<[FeedReviewModel], Never> {
        reviewsModels.eraseToAnyPublisher()
    }
    
    init(coordinator: FeedsCoordinatorable) {
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
        orderOptionModels
            .sink { [weak self] options in
                guard let self,
                      let selectedOrderOption = self.selectedOrderOption else { return }
                let sections = self.converter.createSections(
                    with: self.reviewsModels.value,
                    orderOption: selectedOrderOption
                )
                
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
        
        reviewsModels
            .sink { [weak self] reviews in
                guard let self,
                      let selectedOrderOption = self.selectedOrderOption else { return }
                let sections = self.converter.createSections(
                    with: self.reviewsModels.value,
                    orderOption: selectedOrderOption
                )
                
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
    }
    
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                self?.setupOrderOption()
            }
            .store(in: &cancellables)
    }
    
    private func setupOrderOption() {
        let orderOptions = FeedOrderOption.allCases.map { option in
            FeedOrderOptionModel(
                identifier: option.identifier,
                option: option,
                reviewCount: 20, //TODO: ???? 어떻게 주입할까..
                isSelected: option == .earliest ? true : false
            )
        }
        
        orderOptionModels.send(orderOptions)
    }
    
    func toggleSelectedOrderOption(target identifier: String) {
        //TODO: order option 전환 후, 리스트 갱신 요청
        if let targetIndex = orderOptionModels.value.firstIndex(where: { $0.identifier == identifier }) {
            var tempOrderOptions = orderOptionModels.value
            for index in tempOrderOptions.indices {
                tempOrderOptions[index].isSelected = false
            }
            tempOrderOptions[targetIndex].isSelected.toggle()
            
            orderOptionModels.send(tempOrderOptions)
        }
    }
    
    private func handleAdapterItemTapEvent(input: Input, output: Output) {
        input.adapterActionEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] actionItem in
                guard let self else { return }
                
                switch actionItem {
                case _ as FeedOrderOptionAction:
                    output.presentOrderOptionBottomSheetEventSubject.send(Void())
                case let action as FeedToDetailMoveAction:
                    //TODO: Filter Detail로 이동, FilterID 주입 필요함!!
                    self.coordinator?.pushFilterDetail(with: "filterID/ identifier > \(action.identifier)")
                default:
                    break
                }

            }
            .store(in: &cancellables)
    }
    
   
}
