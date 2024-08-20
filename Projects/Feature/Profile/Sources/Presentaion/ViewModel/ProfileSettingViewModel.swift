//
//  ProfileSettingViewModel.swift
//  Profile
//
//  Created by 이숭인 on 8/19/24.
//

import Foundation
import Combine
import CoreCommonKit
import CoreUIKit
import UIKit
import CoreKeychain

enum ProfileSettingMenu: String, CaseIterable {
    case termsOfService
    case privacyPolicy
    case versionInfo
    case logout
    case accountDeletion
    
    var identifier: String {
        return self.rawValue
    }
    
    var title: String {
           switch self {
           case .termsOfService:
               return "이용약관"
           case .privacyPolicy:
               return "개인정보 처리방침"
           case .versionInfo:
               return "버전 정보"
           case .logout:
               return "로그아웃"
           case .accountDeletion:
               return "탈퇴"
           }
       }
}

extension ProfileSettingViewModel {
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
        
        fileprivate let logoutEventSubject = PassthroughSubject<Void, Never>()
        var logoutEventPublisher: AnyPublisher<Void, Never> {
            logoutEventSubject.eraseToAnyPublisher()
        }
        
        fileprivate let userTerminationEventSubject = PassthroughSubject<Void, Never>()
        var userTerminationEventPublisher: AnyPublisher<Void, Never> {
            userTerminationEventSubject.eraseToAnyPublisher()
        }
    }
}

public final class ProfileSettingViewModel {
    weak var coordinator: ProfileCoordinatorable?
    private let converter = ProfileSectionConverter()
    private var cancellables = Set<AnyCancellable>()
    
    private let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
    
    private var menus: [ProfileSettingMenu] = ProfileSettingMenu.allCases
    
    let logoutEvent = PassthroughSubject<Void, Never>()
    let terminationEvent = PassthroughSubject<Void, Never>()
    
    init(coordinator: ProfileCoordinatorable) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        bind(output: output)
        handleDidSelectEvent(input: input, output: output)
        
        let sections = converter.createSections(menus: menus)
        sectionItems.send(sections)
        
        return output
    }
    
    private func bind(output: Output) {
        sectionItems
            .sink { sections in
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
        
        logoutEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                //TODO: 추후 repository를 만들어 거기서 핸들링하도록 하자
                try? KeychainManager.shared.deleteAuthToken()
                self?.coordinator?.finish()
            }
            .store(in: &cancellables)
        
        terminationEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                //TODO: 추후 repository를 만들어 거기서 핸들링하도록 하자
                try? KeychainManager.shared.deleteAuthToken()
                self?.coordinator?.finish()
            }
            .store(in: &cancellables)
    }
}

extension ProfileSettingViewModel {
    private func handleDidSelectEvent(input: Input, output: Output) {
        input.didSelectItemEvent
            .sink { itemModel in
                guard let menuType = ProfileSettingMenu(rawValue: itemModel.identifier) else {
                    return
                }
                
                switch menuType {
                case .termsOfService:
                    if let url = URL(string: "https://palm-blizzard-691.notion.site/798f1bf6c507421584861961deb173d6") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                case .privacyPolicy:
                    if let url = URL(string: "https://palm-blizzard-691.notion.site/d6a13c767dbd4ab88cb50b594e4ff6a6?pvs=74") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                case .versionInfo:
                    break
                case .logout:
                    output.logoutEventSubject.send(Void())
                case .accountDeletion:
                    output.userTerminationEventSubject.send(Void())
                }
            }
            .store(in: &cancellables)
    }
}
