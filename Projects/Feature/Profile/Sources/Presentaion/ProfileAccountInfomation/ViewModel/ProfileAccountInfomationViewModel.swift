//
//  ProfileAccountInfomationViewModel.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import Foundation
import Combine
import CoreCommonKit
import CoreUIKit
import UIKit

enum ProfileAccountInfomationType {
    case signUpMethod
    case email
    case dateOfJoin
    
    var title: String {
        switch self {
        case .signUpMethod:
            return "가입 방법"
        case .email:
            return "이메일"
        case .dateOfJoin:
            return "가입일"
        }
    }
}

extension ProfileAccountInfomationViewModel {
    struct Input {
        let viewWillAppearEvent: AnyPublisher<Bool, Never>
    }
    
    struct Output {
        fileprivate let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
        var sections: AnyPublisher<[SectionModelType], Never> {
            sectionItems.eraseToAnyPublisher()
        }
    }
}

final class ProfileAccountInfomationViewModel {
    weak var coordinator: ProfileCoordinatorable?
    weak var usecase: ProfileUsecase?
    
    private let converter = ProfileAccountInfomationSectionConverter()
    private var cancellables = Set<AnyCancellable>()
    
    private let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
    
    private let accountInfomation = CurrentValueSubject<ProfileAccountInfomationModel?, Never>(nil)
    
    init(coordinator: ProfileCoordinatorable, usecase: ProfileUsecase) {
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
        
        accountInfomation
            .compactMap { $0 }
            .sink { [weak self] accountInfomation in
                guard let self else { return }
                
                let sections = self.converter.createSections(with: accountInfomation)
                self.sectionItems.send(sections)
            }
            .store(in: &cancellables)
    }
}

//MARK: - Handle View Will Appear Event
extension ProfileAccountInfomationViewModel {
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                self?.requestAccountInfomation()
            }
            .store(in: &cancellables)
    }
}

//MARK: - API Request
extension ProfileAccountInfomationViewModel {
    private func requestAccountInfomation() {
        usecase?.requestAccountInfomation()
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] accountResponse in
                let accountInfomation =  ProfileAccountInfomationModel(
                    signUpMethod: accountResponse.provider,
                    dateOfJoining: accountResponse.createdAt,
                    email: accountResponse.email
                )
                
                self?.accountInfomation.send(accountInfomation)
            })
            .store(in: &cancellables)
    }
}
