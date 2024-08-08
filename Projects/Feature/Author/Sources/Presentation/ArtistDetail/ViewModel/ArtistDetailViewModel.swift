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
    
    private var artistProfileModel = CurrentValueSubject<PurithmVerticalProfileModel?, Never>(nil)
    
    init(coordinator: ArtistCoordinatorable) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        bind(output: output)
        
        handleViewWillAppearEvent(input: input, output: output)
        
        return output
    }
    
    private func bind(output: Output) {
        artistProfileModel
            .compactMap { $0 }
            .sink { [weak self] profileModel in
                guard let self else { return }
                
                let sections = self.converter.createSections(profileModel: profileModel)
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
    }
    
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                self?.setupArtistProfile()
            }
            .store(in: &cancellables)
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
