//
//  FiltersViewModel.swift
//  Filter
//
//  Created by 이숭인 on 7/28/24.
//

import Foundation
import Combine
import CoreUIKit

extension FiltersViewModel {
    struct Input {
        let viewWillAppearEvent: AnyPublisher<Bool, Never>
        let chipDidTapEvent: AnyPublisher<ItemModelType, Never>
        let adapterItemTapEvent: AnyPublisher<ActionEventItem, Never>
    }
    
    struct Output {
        fileprivate let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
        var sections: AnyPublisher<[SectionModelType], Never> {
            sectionItems.compactMap { $0 }.eraseToAnyPublisher()
        }
    }
}

public final class FiltersViewModel {
    private var cancellabels = Set<AnyCancellable>()
    
    weak var coordinator: FiltersCoordinatorable?
    private let sectionConverter = FiltersViewSectionConverter()
    
    private var chipModels = CurrentValueSubject<[FilterChipModel], Never>([])
    private var orderOptionModels = CurrentValueSubject<[FilterOrderOptionModel], Never>([])
    private var selectedOrderOption: FilterOrderOptionModel? {
        orderOptionModels.value.filter { $0.isSelected }.first
    }
    
    var orderOptions: [FilterOrderOptionModel] {
        orderOptionModels.value
    }
    
    // only test
    private var filters = CurrentValueSubject<[FilterItemModel], Never>([
        FilterItemModel(
            identifier: UUID().uuidString,
            filterImageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            planType: .premiumPlus,
            filterTitle: "Rainbow",
            author: "Made by Ehwa",
            isLike: true,
            likeCount: 12
        ),
        FilterItemModel(
            identifier: UUID().uuidString,
            filterImageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            planType: .premium,
            filterTitle: "Blueming",
            author: "Made by Ehwa",
            isLike: false,
            likeCount: 12
        ),
        FilterItemModel(
            identifier: UUID().uuidString,
            filterImageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            planType: .free,
            filterTitle: "title",
            author: "author",
            isLike: false,
            likeCount: 12
        ),
        FilterItemModel(
            identifier: UUID().uuidString,
            filterImageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            planType: .free,
            filterTitle: "title",
            author: "author",
            isLike: false,
            likeCount: 12
        ),
        FilterItemModel(
            identifier: UUID().uuidString,
            filterImageURLString: "",
            planType: .free,
            filterTitle: "title",
            author: "author",
            isLike: false,
            likeCount: 12
        ),
        FilterItemModel(
            identifier: UUID().uuidString,
            filterImageURLString: "",
            planType: .free,
            filterTitle: "title",
            author: "author",
            isLike: false,
            likeCount: 12
        ),
        FilterItemModel(
            identifier: UUID().uuidString,
            filterImageURLString: "",
            planType: .free,
            filterTitle: "title",
            author: "author",
            isLike: false,
            likeCount: 12
        ),
        FilterItemModel(
            identifier: UUID().uuidString,
            filterImageURLString: "",
            planType: .free,
            filterTitle: "title",
            author: "author",
            isLike: false,
            likeCount: 12
        ),
        FilterItemModel(
            identifier: UUID().uuidString,
            filterImageURLString: "",
            planType: .free,
            filterTitle: "title",
            author: "author",
            isLike: false,
            likeCount: 12
        ),
    ])
    
    public init(coordinator: FiltersCoordinatorable) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        bind(output: output)
        
        handleViewWillAppearEvent(input: input, output: output)
        handleChipDidTapEvent(input: input, output: output)
        handleAdapterItemTapEvent(input: input, output: output)
        
        return output
    }
    
    private func bind(output: Output) {
        chipModels
            .compactMap { $0 }
            .sink { [weak self] chips in
                guard let self,
                      let selectedOrderOption = self.selectedOrderOption else { return }
                
                let sections = self.sectionConverter.createSections(
                    chips: chips,
                    orderOption: selectedOrderOption,
                    filters: self.filters.value
                )
                
                output.sectionItems.send(sections)
            }
            .store(in: &cancellabels)
        
        orderOptionModels
            .compactMap { $0 }
            .sink { [weak self] options in
                guard let self,
                      let selectedOrderOption = self.selectedOrderOption else { return }
                let sections = self.sectionConverter.createSections(
                    chips: self.chipModels.value,
                    orderOption: selectedOrderOption,
                    filters: self.filters.value
                )
                
                output.sectionItems.send(sections)
            }
            .store(in: &cancellabels)
        
        filters
            .compactMap { $0 }
            .sink { [weak self] filters in
                guard let self,
                      let selectedOrderOption = self.selectedOrderOption else { return }
                
                let sections = self.sectionConverter.createSections(
                    chips: self.chipModels.value,
                    orderOption: selectedOrderOption,
                    filters: filters
                )
                
                output.sectionItems.send(sections)
            }
            .store(in: &cancellabels)
            
    }
    
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .first()
            .sink { [weak self] _ in
                self?.setupFilterChips() // chips setting
                self?.setupOrderOption() // order option setting
            }
            .store(in: &cancellabels)
    }
    
    private func setupFilterChips() {
        let chips = FilterChipType.allCases.map { type in
            FilterChipModel(
                identifier: type.rawValue,
                title: type.title,
                isSelected: type == .spring ? true : false,
                chipType: type
            )
        }
        chipModels.send(chips)
    }
    
    private func setupOrderOption() {
        let orderOptions = FilterOrderOption.allCases.map { option in
            FilterOrderOptionModel(
                identifier: option.identifier,
                option: option,
                isSelected: option == .earliest ? true : false)
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
}

//MARK: - Private Functions
extension FiltersViewModel {
    private func handleChipDidTapEvent(input: Input, output: Output) {
        input.chipDidTapEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] itemModel in
                guard let self else { return }
                
                if let targetIndex = self.chipModels.value.firstIndex(where: { $0.identifier == itemModel.identifier }) {
                    var tempChipModels = self.chipModels.value
                    
                    for index in tempChipModels.indices {
                        tempChipModels[index].isSelected = false
                    }
                    tempChipModels[targetIndex].isSelected.toggle()
                    
                    self.chipModels.send(tempChipModels)
                    //TODO: chip 상태 전환 후, 리스트 갱신 요청
                }
            }
            .store(in: &cancellabels)
    }
    
    private func handleAdapterItemTapEvent(input: Input, output: Output) {
        input.adapterItemTapEvent
            .sink { [weak self] actionItem in
                guard let self else { return }
                
                switch actionItem {
                case _ as FilterOrderOptionAction:
                    break // 별도의 이벤트를 받아 따로 처리함
                case let action as FilterLikeAction:
                    if let targetIndex = self.filters.value.firstIndex(where: { $0.identifier == action.identifier }) {
                        self.filters.value[targetIndex].isLike.toggle()
                    }
                case let action as FilterDidTapAction:
                    //TODO: 프리미엄 필터인 경우, 바텀시트를 띄우는 분기처리 로직 추가 필요
                    DispatchQueue.main.async {
                        self.coordinator?.pushFilterDetail(with: action.identifier)
                    }
                default:
                    print("invalid action type > \(actionItem)")
                    break
                }
            }
            .store(in: &cancellabels)
    }
}
