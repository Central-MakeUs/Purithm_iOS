//
//  ArtistDetailViewModel.swift
//  Author
//
//  Created by 이숭인 on 8/9/24.
//

import Foundation
import Combine
import CoreUIKit

extension ArtistDetailViewModel {
    struct Input {
        let viewWillAppearEvent: AnyPublisher<Bool, Never>
        let adapterActionEvent: AnyPublisher<ActionEventItem, Never>
        let adapterWillDisplayCellEvent: AnyPublisher<IndexPath, Never>
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
        
        fileprivate let presentFilterRockBottomSheetSubject = PassthroughSubject<Void, Never>()
        var presentFilterRockBottomSheetEvent: AnyPublisher<Void, Never> {
            presentFilterRockBottomSheetSubject.eraseToAnyPublisher()
        }
    }
}


final class ArtistDetailViewModel {
    weak var coordinator: ArtistCoordinatorable?
    weak var usecase: AuthorUsecase?
    private let authorID: String
    
    private var cancellables = Set<AnyCancellable>()
    private let converter = ArtistDetailSectionConverter()
    
    private let sectionItemsSubject = CurrentValueSubject<[SectionModelType], Never>([])
    
    fileprivate let errorSubject = PassthroughSubject<Error, Never>()
    var errorPublisher: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    private var orderOptionModels = CurrentValueSubject<[ArtistDetailOrderOptionModel], Never>([])
    private var selectedOrderOption: ArtistDetailOrderOptionModel? {
        orderOptionModels.value.filter { $0.isSelected }.first
    }
    var orderOptions: [ArtistDetailOrderOptionModel] {
        orderOptionModels.value
    }
    
    var isLast: Bool = true
    
    private var artistProfileModel = CurrentValueSubject<PurithmVerticalProfileModel?, Never>(nil)
    
    private var filterRequestDTO = CurrentValueSubject<AuthorFiltersRequestDTO, Never>(
        AuthorFiltersRequestDTO(
            authorID: "",
            sortedBy: .name,
            page: 0,
            size: 20
        )
    )
    private let loadMoreEvent = PassthroughSubject<Void, Never>()
    
    private var filterModels = CurrentValueSubject<[FilterItemModel], Never>([])
    
    init(coordinator: ArtistCoordinatorable, usecase: AuthorUsecase, authorID: String) {
        self.coordinator = coordinator
        self.usecase = usecase
        self.authorID = authorID
        
        updateRequestParameter()
        requestFilters()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        bind(output: output)
        
        handleViewWillAppearEvent(input: input, output: output)
        handleAdapterItemTapEvent(input: input, output: output)
        handleAdapterVisibleItemEvent(input: input, output: output)
        
        return output
    }
    
    private func bind(output: Output) {
        sectionItemsSubject
            .sink { sections in
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
        
        orderOptionModels
            .sink { [weak self] options in
                guard let self,
                      let selectedOrderOption = self.selectedOrderOption,
                      let profileModel = artistProfileModel.value else { return }
                
                let sections = self.converter.createSections(
                    profileModel: profileModel,
                    option: selectedOrderOption,
                    filters: filterModels.value,
                    isLast: self.isLast
                )
                
                self.sectionItemsSubject.send(sections)
            }
            .store(in: &cancellables)

        
        artistProfileModel
            .compactMap { $0 }
            .sink { [weak self] profileModel in
                guard let self,
                      let selectedOrderOption = self.selectedOrderOption else { return }
                
                let sections = self.converter.createSections(
                    profileModel: profileModel,
                    option: selectedOrderOption,
                    filters: filterModels.value,
                    isLast: self.isLast
                )
                
                self.sectionItemsSubject.send(sections)
            }
            .store(in: &cancellables)
        
        filterModels
            .compactMap { $0 }
            .sink { [weak self] filters in
                guard let self,
                      let selectedOrderOption = self.selectedOrderOption,
                      let profileModel = artistProfileModel.value else { return }
                
                let sections = self.converter.createSections(
                    profileModel: profileModel,
                    option: selectedOrderOption,
                    filters: filters,
                    isLast: self.isLast
                )
                
                self.sectionItemsSubject.send(sections)
            }
            .store(in: &cancellables)
        
        loadMoreEvent
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.filterRequestDTO.value.page += 1
                self?.requestFilters()
            }
            .store(in: &cancellables)
    }
    
    func toggleSelectedOrderOption(target identifier: String) {
        if let targetIndex = orderOptionModels.value.firstIndex(where: { $0.identifier == identifier }) {
            var tempOrderOptions = orderOptionModels.value
            for index in tempOrderOptions.indices {
                tempOrderOptions[index].isSelected = false
            }
            tempOrderOptions[targetIndex].isSelected.toggle()
            
            orderOptionModels.send(tempOrderOptions)
            
            filterRequestDTO.value.sortedBy = {
                switch tempOrderOptions[targetIndex].option {
                case .name:
                    return AuthorFiltersRequestDTO.Sort.name
                case .rating:
                    return AuthorFiltersRequestDTO.Sort.rating
                case .pureIndexHigh:
                    return AuthorFiltersRequestDTO.Sort.pureIndexHigh
                }
            }()
            filterRequestDTO.value.page = 0
            
            requestFilters()
        }
    }
    
    private func updateRequestParameter() {
        filterRequestDTO.value.authorID = authorID
    }
}

//MARK: - Handle viewWillAppear Event
extension ArtistDetailViewModel {
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                self?.setupOrderOption()
                self?.requestAuthorInformation()
            }
            .store(in: &cancellables)
    }
    
    private func setupOrderOption() {
        let orderOptions = ArtistDetailOrderOption.allCases.map { option in
            ArtistDetailOrderOptionModel(
                identifier: option.identifier,
                option: option,
                filterCount: 0,
                isSelected: option == .name ? true : false)
        }
        
        orderOptionModels.send(orderOptions)
    }
}

//MARK: - Handle Adapter Event
extension ArtistDetailViewModel {
    private func handleAdapterItemTapEvent(input: Input, output: Output) {
        input.adapterActionEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] actionItem in
                guard let self else { return }
                
                switch actionItem {
                case _ as ArtistDetailOrderOptionAction:
                    output.presentOrderOptionBottomSheetEventSubject.send(Void())
                case let action as FilterDidTapAction:
                    if let targetIndex = self.filterModels.value.firstIndex(where: { $0.identifier == action.identifier }) {
                        if self.filterModels.value[targetIndex].canAccess {
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
                case let action as FilterLikeAction:
                    var newFilters = self.filterModels.value
                    
                    if let targetIndex = newFilters.firstIndex(where: { $0.identifier == action.identifier }) {
                        newFilters[targetIndex].isLike.toggle()
                        
                        if newFilters[targetIndex].isLike {
                            newFilters[targetIndex].likeCount += 1
                            self.requestLike(with: action.identifier)
                        } else {
                            newFilters[targetIndex].likeCount -= 1
                            self.requestUnlike(with: action.identifier)
                        }
                        
                        self.filterModels.send(newFilters)
                    }
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - Handle Will Display
extension ArtistDetailViewModel {
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
            .store(in: &cancellables)
    }
}


extension ArtistDetailViewModel {
    private func requestLike(with filterID: String) {
        usecase?.requestLike(with: filterID)
            .sink { _ in } receiveValue: { _ in
                //TODO: 찜 토스트 띄워야함
                print("//TODO: 찜 토스트 띄워야함")
            }
            .store(in: &cancellables)
    }
    
    private func requestUnlike(with filterID: String) {
        usecase?.requestUnlike(with: filterID)
            .sink { _ in } receiveValue: { _ in
                //TODO: 찜 해제 토스트 띄워야함
                print("//TODO: 찜 해제 토스트 띄워야함")
            }
            .store(in: &cancellables)
    }
    
    private func requestAuthorInformation() {
        usecase?.requestAuthor(with: self.authorID)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                let convertedResponse = response.convertModel()
                self?.artistProfileModel.send(convertedResponse)
            })
            .store(in: &cancellables)
    }
    
    private func requestFilters() {
        usecase?.requestFiltersByAuthor(with: filterRequestDTO.value)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                let convertedFilters = response.filters.map { $0.convertModel() }
                self?.isLast = response.isLast
                
                self?.changeFilterModels(with: convertedFilters)
                
                let targetIdentifier = self?.selectedOrderOption?.identifier ?? ""
                if let targetIndex = self?.orderOptionModels.value.firstIndex(where: {
                    $0.identifier == targetIdentifier
                }) {
                    self?.orderOptionModels.value[targetIndex].filterCount = convertedFilters.count
                }
            })
            .store(in: &cancellables)
    }
    
    private func changeFilterModels(with convertedModel: [FilterItemModel]) {
        // 첫 페이지인 경우
        if filterRequestDTO.value.page == .zero {
            filterModels.send(convertedModel)
        } else { // 다음 페이지인 경우
            var newFilters = filterModels.value
            newFilters.append(contentsOf: convertedModel)
            
            filterModels.send(newFilters)
        }
    }
}
