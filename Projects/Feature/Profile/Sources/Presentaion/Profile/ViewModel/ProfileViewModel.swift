//
//  ProfileViewModel.swift
//  Profile
//
//  Created by 이숭인 on 8/21/24.
//

import Foundation
import Combine
import CoreCommonKit
import CoreUIKit
import UIKit

extension ProfileViewModel {
    struct Input {
        let viewWillAppearEvent: AnyPublisher<Bool, Never>
        let didSelectItemEvent: AnyPublisher<ItemModelType, Never>
        let adapterActionEvent: AnyPublisher<ActionEventItem, Never>
    }
    
    struct Output {
        fileprivate let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
        var sections: AnyPublisher<[SectionModelType], Never> {
            sectionItems.eraseToAnyPublisher()
        }
    }
}

final class ProfileViewModel {
    weak var coordinator: ProfileCoordinatorable?
    weak var usecase: ProfileUsecase?
    
    private let converter = ProfileSectionConverter()
    private var cancellables = Set<AnyCancellable>()
    
    private let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
    
    private let profileModel = CurrentValueSubject<PurithmVerticalProfileModel?, Never>(nil)
    
    init(
        coordinator: ProfileCoordinatorable,
        usecase: ProfileUsecase
    ) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        bind(output: output)
        handleViewWillAppearEvent(input: input, output: output)
        
        return output
    }
    
    private func bind(output: Output) {
        sectionItems
            .sink { sections in
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
        
        profileModel
            .compactMap { $0 }
            .sink { [weak self] profileModel in
                let sections = self?.converter.createSections(with: profileModel) ?? []
                self?.sectionItems.send(sections)
            }
            .store(in: &cancellables)
    }
}

//MARK: - Handle View Will Appear Event
extension ProfileViewModel {
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                self?.requestMyInfomation()
            }
            .store(in: &cancellables)
    }
}

//MARK: - Request API
extension ProfileViewModel {
    private func requestMyInfomation() {
        usecase?.requestMyInfomation()
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] myInfomationResponse in
                let profileModel = PurithmVerticalProfileModel(
                    identifier: "my_profile",
                    type: .user,
                    name: myInfomationResponse.userName,
                    profileURLString: myInfomationResponse.profileThumbnailString,
                    introduction: ""
                )
                
                self?.profileModel.send(profileModel)
            })
            .store(in: &cancellables)
    }
}
