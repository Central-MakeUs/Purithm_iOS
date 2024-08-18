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
    
    private var artistProfileModel = CurrentValueSubject<PurithmVerticalProfileModel?, Never>(nil)
    
    private var filterRequestModel = CurrentValueSubject<AuthorFiltersRequestDTO, Never>(
        AuthorFiltersRequestDTO(
            authorID: "",
            sortedBy: .earliest,
            page: 0,
            size: 20
        )
    )
    private var filterModels = CurrentValueSubject<[FilterItemModel], Never>([])
    
    init(coordinator: ArtistCoordinatorable, usecase: AuthorUsecase, authorID: String) {
        self.coordinator = coordinator
        self.usecase = usecase
        self.authorID = authorID
        
        updateRequestParameter()
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
                      let selectedOrderOption = self.selectedOrderOption,
                      let profileModel = artistProfileModel.value else { return }
                
                let sections = self.converter.createSections(
                    profileModel: profileModel,
                    option: selectedOrderOption,
                    filters: filterModels.value
                )
                
                output.sectionItems.send(sections)
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
                    filters: filterModels.value
                )
                output.sectionItems.send(sections)
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
                    filters: filters
                )
                
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
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
            
            filterRequestModel.value.sortedBy = {
                switch tempOrderOptions[targetIndex].option {
                case .earliest:
                    return AuthorFiltersRequestDTO.Sort.earliest
                case .latest:
                    return AuthorFiltersRequestDTO.Sort.latest
                case .pureIndexHigh:
                    return AuthorFiltersRequestDTO.Sort.pureIndexHigh
                }
            }()
            
            requestFilters()
        }
    }
    
    private func updateRequestParameter() {
        filterRequestModel.value.authorID = authorID
    }
}

//MARK: - Handle viewWillAppear Event
extension ArtistDetailViewModel {
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                self?.setupOrderOption()
                self?.requestAuthorInformation()
                self?.requestFilters()
            }
            .store(in: &cancellables)
    }
    
    private func setupOrderOption() {
        let orderOptions = ArtistDetailOrderOption.allCases.map { option in
            ArtistDetailOrderOptionModel(
                identifier: option.identifier,
                option: option,
                filterCount: 20, //TODO: ??? 어떤 데이터로 주입하나?
                isSelected: option == .earliest ? true : false)
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
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}


extension ArtistDetailViewModel {
    private func requestAuthorInformation() {
        usecase?.requestAuthor(with: self.authorID)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                let convertedResponse = response.convertModel()
                self?.artistProfileModel.send(convertedResponse)
            })
            .store(in: &cancellables)
    }
    
    private func requestFilters() {
        usecase?.requestFiltersByAuthor(with: filterRequestModel.value)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                let convertedFilters = response.filters.map { $0.convertModel() }
                
                self?.filterModels.send(convertedFilters)
                
                let targetIdentifier = self?.selectedOrderOption?.identifier ?? ""
                if let targetIndex = self?.orderOptionModels.value.firstIndex(where: {
                    $0.identifier == targetIdentifier
                }) {
                    self?.orderOptionModels.value[targetIndex].filterCount = convertedFilters.count
                }
            })
            .store(in: &cancellables)
    }
}
