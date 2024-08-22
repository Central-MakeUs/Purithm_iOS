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
    weak var usecase: FeedUsecase?
    
    var cancellables = Set<AnyCancellable>()
    let converter = FeedsSectionConverter()
    
    private var orderOptionModels = CurrentValueSubject<[FeedOrderOptionModel], Never>([])
    private var selectedOrderOption: FeedOrderOptionModel? {
        orderOptionModels.value.filter { $0.isSelected }.first
    }
    var orderOptions: [FeedOrderOptionModel] {
        orderOptionModels.value
    }
    
    var reportOption: [FeedReportOption] = FeedReportOption.allCases
    
    private let feedRequestDTO = CurrentValueSubject<FeedsRequestDTO, Never>(
        FeedsRequestDTO(sortedBy: .earliest)
    )
    
    private var reviewsModels = CurrentValueSubject<[FeedReviewModel], Never>([])
    var reviews: AnyPublisher<[FeedReviewModel], Never> {
        reviewsModels.eraseToAnyPublisher()
    }
    
    private var filterInformations = CurrentValueSubject<[(name: String, thumbnail: String)], Never>([])
    
    private let reportEventSubject = PassthroughSubject<Void, Never>()
    var reportEventPublisher: AnyPublisher<Void, Never> {
        reportEventSubject.eraseToAnyPublisher()
    }
    
    init(coordinator: FeedsCoordinatorable, usecase: FeedUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
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
                    filterInfo: self.filterInformations.value,
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
                    filterInfo: self.filterInformations.value,
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
                self?.requestFeeds()
            }
            .store(in: &cancellables)
    }
    
    private func setupOrderOption() {
        let orderOptions = FeedOrderOption.allCases.map { option in
            FeedOrderOptionModel(
                identifier: option.identifier,
                option: option,
                reviewCount: 0,
                isSelected: option == .earliest ? true : false
            )
        }
        
        orderOptionModels.send(orderOptions)
    }
    
    func toggleSelectedOrderOption(target identifier: String) {
        if let targetIndex = orderOptionModels.value.firstIndex(where: { $0.identifier == identifier }) {
            var tempOrderOptions = orderOptionModels.value
            for index in tempOrderOptions.indices {
                tempOrderOptions[index].isSelected = false
            }
            tempOrderOptions[targetIndex].isSelected.toggle()
            
            orderOptionModels.send(tempOrderOptions)
            
            feedRequestDTO.value.sortedBy = {
                switch tempOrderOptions[targetIndex].option {
                case .earliest:
                    return FeedsRequestDTO.Sort.earliest
                case .latest:
                    return FeedsRequestDTO.Sort.latest
                case .pureIndexHigh:
                    return FeedsRequestDTO.Sort.pureIndexHigh
                }
            }()
            
            requestFeeds()
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
                    self.coordinator?.pushFilterDetail(with: action.identifier)
                case _ as FeedReportAction:
                    self.reportEventSubject.send(())
                default:
                    break
                }

            }
            .store(in: &cancellables)
    }
}

extension FeedsViewModel {
    private func requestFeeds() {
        usecase?.reqeustFeeds(with: feedRequestDTO.value)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                let convertedResponse = response.map { $0.convertModel() }
                let informations = response.map { $0.retriveFilterInformation() }
                
                self?.filterInformations.send(informations)
                self?.reviewsModels.send(convertedResponse)
                
                // 선택한 옵션의 리스트 개수를 계산
                let targetIdentifier = self?.selectedOrderOption?.identifier ?? ""
                if let targetIndex = self?.orderOptionModels.value.firstIndex(where: {
                    $0.identifier == targetIdentifier
                }) {
                    self?.orderOptionModels.value[targetIndex].reviewCount = convertedResponse.count
                }
            })
            .store(in: &cancellables)
    }
}
