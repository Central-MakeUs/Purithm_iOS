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
        let adapterWillDisplayCellEvent: AnyPublisher<IndexPath, Never>
    }
    
    struct Output {
        fileprivate let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
        var sections: AnyPublisher<[SectionModelType], Never> {
            sectionItems.compactMap { $0 }.eraseToAnyPublisher()
        }
        
        fileprivate let sectionEmptySubject = PassthroughSubject<Bool, Never>()
        var sectionEmptyPublisher: AnyPublisher<Bool, Never> {
            sectionEmptySubject.eraseToAnyPublisher()
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
    
    private let sectionItemsSubject = CurrentValueSubject<[SectionModelType], Never>([])
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
            sortedBy: .name,
            page: 0,
            size: 20
        )
    )
    private let loadMoreEvent = PassthroughSubject<Void, Never>()
    
    private var filters: [FilterItemModel] = []
    private var filtersSubject = CurrentValueSubject<[FilterItemModel], Never>([])
    private var isLast: Bool = true
    private var isFirstLoadingState = CurrentValueSubject<Bool, Never>(false)
    var firstLoadingStatePublisher: AnyPublisher<Bool, Never> {
        isFirstLoadingState.eraseToAnyPublisher()
    }
    
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
        handleAdapterVisibleItemEvent(input: input, output: output)
        
        return output
    }
    
    private func bind(output: Output) {
        sectionItemsSubject
            .sink { sections in
                output.sectionItems.send(sections)
            }
            .store(in: &cancellabels)

        chipModels
            .compactMap { $0 }
            .sink { [weak self] chips in
                guard let self else { return }
                let sections = self.chipSectionConverter.createSections(chips: chips)
                output.chipSectionItems.send(sections)
            }
            .store(in: &cancellabels)
        
        orderOptionModels
            .filter { [weak self] _ in
                !(self?.filters.isEmpty ?? true)
            }
            .compactMap { $0 }
            .sink { [weak self] options in
                guard let self,
                      let selectedOrderOption = self.selectedOrderOption else { return }
                let sections = self.sectionConverter.createSections(
                    orderOption: selectedOrderOption,
                    filters: self.filters,
                    isLast: self.isLast
                )
                
                output.sectionEmptySubject.send(self.filters.isEmpty)
                self.sectionItemsSubject.send(sections)
            }
            .store(in: &cancellabels)
        
        filtersSubject
            .compactMap { $0 }
            .sink { [weak self] filters in
                guard let self,
                      let selectedOrderOption = self.selectedOrderOption else { return }
                
                let sections = self.sectionConverter.createSections(
                    orderOption: selectedOrderOption,
                    filters: filters, 
                    isLast: self.isLast
                )
                
                output.sectionEmptySubject.send(filters.isEmpty)
                self.sectionItemsSubject.send(sections)
            }
            .store(in: &cancellabels)
            
        loadMoreEvent
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.filtersRequestDTO.value.page += 1
                self?.requestFilters()
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
                isSelected: option == .name ? true : false)
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
            
            filtersRequestDTO.value.page = 0
            filtersRequestDTO.value.sortedBy = {
                switch tempOrderOptions[targetIndex].option {
                case .name:
                    return FilterListRequestDTO.Sort.name
                case .rating:
                    return FilterListRequestDTO.Sort.rating
                case .pureIndexHigh:
                    return FilterListRequestDTO.Sort.pureIndexHigh
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
                    filtersRequestDTO.value.page = 0
                    filtersRequestDTO.value.sortedBy = .name
                    
                    var tempOrderOptions = orderOptionModels.value
                    for index in tempOrderOptions.indices {
                        tempOrderOptions[index].isSelected = tempOrderOptions[index].option == .name ? true : false
                    }
                    orderOptionModels.send(tempOrderOptions)
                    
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

//MARK: - HandleVisibleItem
extension FiltersViewModel {
    private func handleAdapterVisibleItemEvent(input: Input, output: Output) {
        input.adapterWillDisplayCellEvent
            .sink { [weak self] indexPath in
                guard let section = self?.sectionItemsSubject.value[safe: indexPath.section] else {
                    return
                }
                //TODO: 이건 상수화 해야할듯
                if section.identifier == "load_more_section" {
                    // 최대 페이지와 isLast값 비교 후
                    if !(self?.isLast ?? true) {
                        self?.loadMoreEvent.send(Void())
                    }
                }
            }
            .store(in: &cancellabels)
    }
}

//MARK: - Filter List Request
extension FiltersViewModel {
    private func requestFilters() {
        if filtersRequestDTO.value.page == 0 {
            // 첫 페이지일때만 로딩
            isFirstLoadingState.send(true)
        }
        
        usecase?.requestFilterList(with: filtersRequestDTO.value)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                guard let self else { return }
                isFirstLoadingState.send(false)
                
                let filters = response.filters.map { $0.convertModel() }
                self.isLast = response.isLast
                
                // 첫 페이지인 경우
                if self.filtersRequestDTO.value.page == .zero {
                    let filters = response.filters.map { $0.convertModel() }
                    self.isLast = response.isLast
                    
                    self.filters = filters
                    self.filtersSubject.send(filters)
                } else { // 다음 페이지인 경우
                    var newFilters = self.filters
                    
                    newFilters.append(contentsOf: filters)
                    
                    self.filters = newFilters
                    self.filtersSubject.send(newFilters)
                }
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
