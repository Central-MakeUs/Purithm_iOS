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
        fileprivate let chipSectionItems = CurrentValueSubject<[SectionModelType], Never>([])
        var chipSections: AnyPublisher<[SectionModelType], Never> {
            chipSectionItems.compactMap { $0 }.eraseToAnyPublisher()
        }
        
        fileprivate let presentOrderOptionBottomSheetEventSubject = PassthroughSubject<Void, Never>()
        var presentOrderOptionBottomSheetEvent: AnyPublisher<Void, Never> {
            presentOrderOptionBottomSheetEventSubject.eraseToAnyPublisher()
        }
        fileprivate let presentFilterRockBottomSheetSubject = PassthroughSubject<Void, Never>()
        var presentFilterRockBottomSheetEvent: AnyPublisher<Void, Never> {
            presentFilterRockBottomSheetSubject.eraseToAnyPublisher()
        }
    }
}

public final class FiltersViewModel {
    private var cancellabels = Set<AnyCancellable>()
    
    weak var coordinator: FiltersCoordinatorable?
    weak var usecase: FiltersUseCase?
    private let sectionConverter = FiltersViewSectionConverter()
    private let chipSectionConverter = FiltersChipSectionConverter()
    
    private var chipModels = CurrentValueSubject<[FilterChipModel], Never>([])
    private var orderOptionModels = CurrentValueSubject<[FilterOrderOptionModel], Never>([])
    private var selectedOrderOption: FilterOrderOptionModel? {
        orderOptionModels.value.filter { $0.isSelected }.first
    }
    
    var orderOptions: [FilterOrderOptionModel] {
        orderOptionModels.value
    }
    fileprivate let errorSubject = PassthroughSubject<Error, Never>()
    var errorPublisher: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    // Data
    private var filtersRequestDTO = CurrentValueSubject<FilterListRequestDTO, Never>(
        FilterListRequestDTO(
            tag: .all,
            sortedBy: .earliest,
            page: 0,
            size: 20
        )
    )
    
    private var filters: [FilterItemModel] = []
    private var filtersSubject = CurrentValueSubject<[FilterItemModel], Never>([])
    private var isLast: Bool = true
    
    public init(coordinator: FiltersCoordinatorable, usecase: FiltersUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
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
                guard let self else { return }
                let sections = self.chipSectionConverter.createSections(chips: chips)
                output.chipSectionItems.send(sections)
            }
            .store(in: &cancellabels)
        
        orderOptionModels
            .compactMap { $0 }
            .sink { [weak self] options in
                guard let self,
                      let selectedOrderOption = self.selectedOrderOption else { return }
                let sections = self.sectionConverter.createSections(
                    orderOption: selectedOrderOption,
                    filters: self.filters
                )
                
                output.sectionItems.send(sections)
            }
            .store(in: &cancellabels)
        
        filtersSubject
            .compactMap { $0 }
            .sink { [weak self] filters in
                guard let self,
                      let selectedOrderOption = self.selectedOrderOption else { return }
                
                let sections = self.sectionConverter.createSections(
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
                
                self?.requestFilters()
            }
            .store(in: &cancellabels)
    }
    
    private func setupFilterChips() {
        let chips = FilterChipType.allCases.map { type in
            FilterChipModel(
                identifier: type.rawValue,
                title: type.title,
                isSelected: type == .all ? true : false,
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
        if let targetIndex = orderOptionModels.value.firstIndex(where: { $0.identifier == identifier }) {
            var tempOrderOptions = orderOptionModels.value
            for index in tempOrderOptions.indices {
                tempOrderOptions[index].isSelected = false
            }
            tempOrderOptions[targetIndex].isSelected.toggle()
            
            orderOptionModels.send(tempOrderOptions)
            
            filtersRequestDTO.value.sortedBy = {
                switch tempOrderOptions[targetIndex].option {
                case .earliest:
                    return FilterListRequestDTO.Sort.earliest
                case .latest:
                    return FilterListRequestDTO.Sort.latest
                case .pureIndexHigh:
                    return FilterListRequestDTO.Sort.popular
                }
            }()
            
            requestFilters()
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
                    filtersRequestDTO.value.tag = tempChipModels[targetIndex].chipType
                    self.requestFilters()
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
                    output.presentOrderOptionBottomSheetEventSubject.send(Void())
                case let action as FilterLikeAction:
                    if let targetIndex = self.filters.firstIndex(where: { $0.identifier == action.identifier }) {
                        self.filters[targetIndex].isLike.toggle()
                        
                        if self.filters[targetIndex].isLike {
                            self.filters[targetIndex].likeCount += 1
                            self.requestLike(with: action.identifier)
                        } else {
                            self.filters[targetIndex].likeCount -= 1
                            self.requestUnlike(with: action.identifier)
                        }
                        
                        self.filtersSubject.send(filters)
                    }
                case let action as FilterDidTapAction:
                    if let targetIndex = self.filters.firstIndex(where: { $0.identifier == action.identifier }) {
                        if self.filters[targetIndex].canAccess {
                            DispatchQueue.main.async {
                                self.coordinator?.pushFilterDetail(with: action.identifier)
                            }
                        } else {
                            output.presentFilterRockBottomSheetSubject.send(Void())
                        }
                    } else {
                        let emptyError = NSError(domain: "잘못된 ID 값 입니다.\nID: \(action.identifier)", code: 0, userInfo: nil)
                        self.errorSubject.send(emptyError)
                    }
                default:
                    print("invalid action type > \(actionItem)")
                    break
                }
            }
            .store(in: &cancellabels)
    }
}

//MARK: - Filter List Request
extension FiltersViewModel {
    private func requestFilters() {
        usecase?.requestFilterList(with: filtersRequestDTO.value)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                let filters = response.filters.map { $0.convertModel() }
                self?.isLast = response.isLast
                
                self?.filters = filters
                self?.filtersSubject.send(filters)
            })
            .store(in: &cancellabels)
    }
    
    private func requestLike(with filterID: String) {
        usecase?.requestLike(with: filterID)
            .sink { _ in } receiveValue: { _ in
                //TODO: 찜 토스트 띄워야함
                print("//TODO: 찜 토스트 띄워야함")
            }
            .store(in: &cancellabels)
    }
    
    private func requestUnlike(with filterID: String) {
        usecase?.requestUnlike(with: filterID)
            .sink { _ in } receiveValue: { _ in
                //TODO: 찜 해제 토스트 띄워야함
                print("//TODO: 찜 해제 토스트 띄워야함")
            }
            .store(in: &cancellabels)
    }
}
