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
        
        fileprivate let presentOrderOptionBottomSheetEventSubject = PassthroughSubject<Void, Never>()
        var presentOrderOptionBottomSheetEvent: AnyPublisher<Void, Never> {
            presentOrderOptionBottomSheetEventSubject.eraseToAnyPublisher()
        }
    }
}


final class ArtistsViewModel {
    weak var coordinator: ArtistCoordinatorable?
    var cancellables = Set<AnyCancellable>()
    let converter = ArtistsSectionConverter()
    
    private var orderOptionModels = CurrentValueSubject<[ArtistOrderOptionModel], Never>([])
    private var selectedOrderOption: ArtistOrderOptionModel? {
        orderOptionModels.value.filter { $0.isSelected }.first
    }
    var orderOptions: [ArtistOrderOptionModel] {
        orderOptionModels.value
    }
    
    private var artistModels = CurrentValueSubject<[ArtistScrapModel], Never>([
        ArtistScrapModel(
            identifier: UUID().uuidString,
            imageURLStrings: ["https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0", "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0"],
            artist: "Mumu",
            artistProfileURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            content: "순간의 풍경을 담는 작가, 이화입니다."
        ),
        ArtistScrapModel(
            identifier: UUID().uuidString,
            imageURLStrings: ["https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
                              "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
                              "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0"],
            artist: "Mumu",
            artistProfileURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            content: "순간의 풍경을 담는 작가, 이화입니다."
        ),
        ArtistScrapModel(
            identifier: UUID().uuidString,
            imageURLStrings: ["https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0"],
            artist: "Mumu",
            artistProfileURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            content: "순간의 풍경을 담는 작가, 이화입니다."
        ),
        ArtistScrapModel(
            identifier: UUID().uuidString,
            imageURLStrings: ["https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0"],
            artist: "Mumu",
            artistProfileURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            content: "순간의 풍경을 담는 작가, 이화입니다."
        ),
    ])
    
    var artists: AnyPublisher<[ArtistScrapModel], Never> {
        artistModels.eraseToAnyPublisher()
    }
    
    
    init(coordinator: ArtistCoordinatorable) {
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
                    with: self.artistModels.value,
                    orderOption: selectedOrderOption
                )
                
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
                
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
    }
    
    private func setupOrderOption() {
        let orderOptions = ArtistOrderOption.allCases.map { option in
            ArtistOrderOptionModel(
                identifier: option.identifier,
                option: option,
                artistCount: 20, //TODO: ??? 어떤 데이터로 주입하나?
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
        }
    }
}

//MARK: - Handler
extension ArtistsViewModel {
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                self?.setupOrderOption()
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
                case _ as ArtistScrapItemAction:
                    //TODO: 작가 ID 주입 필요!!!
                    self.coordinator?.pushArtistDetail(with: "artist ID")
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

