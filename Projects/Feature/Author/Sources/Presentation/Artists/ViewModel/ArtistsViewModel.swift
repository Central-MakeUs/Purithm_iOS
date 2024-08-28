//
//  ArtistsViewModel.swift
//  Author
//
//  Created by 이숭인 on 8/8/24.
//

import Foundation
import Combine
import CoreCommonKit
import CoreUIKit


extension ArtistsViewModel {
    struct Input {
        let viewWillAppearEvent: AnyPublisher<Bool, Never>
        let adapterActionEvent: AnyPublisher<ActionEventItem, Never>
    }
    
    struct Output {
        fileprivate let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
        var sections: AnyPublisher<[SectionModelType], Never> {
            sectionItems.eraseToAnyPublisher()
        }
        
        fileprivate let sectionEmptySubject = PassthroughSubject<Bool, Never>()
        var sectionEmptyPublisher: AnyPublisher<Bool, Never> {
            sectionEmptySubject.eraseToAnyPublisher()
        }
        
        fileprivate let presentOrderOptionBottomSheetEventSubject = PassthroughSubject<Void, Never>()
        var presentOrderOptionBottomSheetEvent: AnyPublisher<Void, Never> {
            presentOrderOptionBottomSheetEventSubject.eraseToAnyPublisher()
        }
    }
}


final class ArtistsViewModel {
    weak var coordinator: ArtistCoordinatorable?
    weak var usecase: AuthorUsecase?
    
    var cancellables = Set<AnyCancellable>()
    let converter = ArtistsSectionConverter()
    
    private var orderOptionModels = CurrentValueSubject<[ArtistOrderOptionModel], Never>([])
    private var selectedOrderOption: ArtistOrderOptionModel? {
        orderOptionModels.value.filter { $0.isSelected }.first
    }
    var orderOptions: [ArtistOrderOptionModel] {
        orderOptionModels.value
    }
    
    //Data
    private var artistsRequestDTO = CurrentValueSubject<AuthorsRequestDTO, Never>(
        AuthorsRequestDTO(sorted: .earliest)
    )
    
    private var artistModels = CurrentValueSubject<[ArtistScrapModel], Never>([])
    
    var artists: AnyPublisher<[ArtistScrapModel], Never> {
        artistModels.eraseToAnyPublisher()
    }
    
    private var isFirstLoadingState = CurrentValueSubject<Bool, Never>(false)
    var firstLoadingStatePublisher: AnyPublisher<Bool, Never> {
        isFirstLoadingState.eraseToAnyPublisher()
    }
    
    init(coordinator: ArtistCoordinatorable, usecase: AuthorUsecase) {
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
                    with: self.artistModels.value,
                    orderOption: selectedOrderOption
                )
                
                output.sectionEmptySubject.send(artistModels.value.isEmpty)
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
        
        artistModels
            .sink { [weak self] reviews in
                guard let self,
                      let selectedOrderOption = self.selectedOrderOption else { return }
                let sections = self.converter.createSections(
                    with: self.artistModels.value,
                    orderOption: selectedOrderOption
                )
                
                output.sectionEmptySubject.send(artistModels.value.isEmpty)
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
    }
    
    private func setupOrderOption() {
        let orderOptions = ArtistOrderOption.allCases.map { option in
            ArtistOrderOptionModel(
                identifier: option.identifier,
                option: option,
                artistCount: 0,
                isSelected: option == .filterCountHigh ? true : false)
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
            
            artistsRequestDTO.value.sorted = {
                switch tempOrderOptions[targetIndex].option {
                case .earliest:
                    return AuthorsRequestDTO.Sort.earliest
                case .latest:
                    return AuthorsRequestDTO.Sort.latest
                case .filterCountHigh:
                    return AuthorsRequestDTO.Sort.filterCountHigh
                }
            }()
            
            requestArtists()
        }
    }
}

//MARK: - Handler
extension ArtistsViewModel {
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                self?.setupOrderOption()
                self?.requestArtists()
            }
            .store(in: &cancellables)
    }
    
    private func handleAdapterItemTapEvent(input: Input, output: Output) {
        input.adapterActionEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] actionItem in
                guard let self else { return }
                
                switch actionItem {
                case _ as ArtistOrderOptionAction:
                    output.presentOrderOptionBottomSheetEventSubject.send(Void())
                case let action as ArtistScrapItemAction:
                    self.coordinator?.pushArtistDetail(with: action.identifier)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

extension ArtistsViewModel {
    private func requestArtists() {
        // 새로 요청시 로딩
        isFirstLoadingState.send(true)
        
        usecase?.requestAuthors(with: artistsRequestDTO.value)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                // 로딩 종료
                self?.isFirstLoadingState.send(false)
                
                let convertedResponse = response.map { $0.convertModel() }
                self?.artistModels.send(convertedResponse)
                
                let targetIdentifier = self?.selectedOrderOption?.identifier ?? ""
                if let targetIndex = self?.orderOptionModels.value.firstIndex(where: {
                    $0.identifier == targetIdentifier
                }) {
                    self?.orderOptionModels.value[targetIndex].artistCount = convertedResponse.count
                }
            })
            .store(in: &cancellables)
    }
}


