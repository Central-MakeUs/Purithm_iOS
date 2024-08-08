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
    }
}


final class ArtistDetailViewModel {
    weak var coordinator: ArtistCoordinatorable?
    private var cancellables = Set<AnyCancellable>()
    private let converter = ArtistDetailSectionConverter()
    
    private var orderOptionModels = CurrentValueSubject<[ArtistDetailOrderOptionModel], Never>([])
    private var selectedOrderOption: ArtistDetailOrderOptionModel? {
        orderOptionModels.value.filter { $0.isSelected }.first
    }
    var orderOptions: [ArtistDetailOrderOptionModel] {
        orderOptionModels.value
    }
    
    private var artistProfileModel = CurrentValueSubject<PurithmVerticalProfileModel?, Never>(nil)
    
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
                      let selectedOrderOption = self.selectedOrderOption,
                      let profileModel = artistProfileModel.value else { return }
                
                let sections = self.converter.createSections(
                    profileModel: profileModel,
                    option: selectedOrderOption
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
                    option: selectedOrderOption
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
        }
    }
}

//MARK: - Handle viewWillAppear Event
extension ArtistDetailViewModel {
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                self?.setupOrderOption()
                self?.setupArtistProfile()
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
    
    private func setupArtistProfile() {
        let profileModel = PurithmVerticalProfileModel(
            identifier: UUID().uuidString,
            type: .artist,
            name: "Greta",
            profileURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            introduction: "순간의 풍경을 담는 작가, 이화입니다."
        )
        
        artistProfileModel.send(profileModel)
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
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
