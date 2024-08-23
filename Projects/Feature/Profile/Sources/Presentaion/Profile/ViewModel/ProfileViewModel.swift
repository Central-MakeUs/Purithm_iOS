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
    
    let profileSettingMoveEvent = PassthroughSubject<Void, Never>()
    
    private let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
    
    private let userInfomationModel = CurrentValueSubject<ProfileUserInfomationModel?, Never>(nil)
    private let profileMenus: [ProfileMenu] = ProfileMenu.allCases
    
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
        handleAdapterActionEvent(input: input, output: output)
        
        return output
    }
    
    private func bind(output: Output) {
        sectionItems
            .sink { sections in
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
        
        userInfomationModel
            .compactMap { $0 }
            .sink { [weak self] profileModel in
                guard let self else { return }
                let sections = self.converter.createSections(with: profileModel, profileMenu: self.profileMenus)
                
                self.sectionItems.send(sections)
            }
            .store(in: &cancellables)
        
        profileSettingMoveEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.coordinator?.pushProfileSettingViewContriller()
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

//MARK: Handle Action Event
extension ProfileViewModel {
    private func handleAdapterActionEvent(input: Input, output: Output) {
        input.adapterActionEvent
            .sink { [weak self] actionItem in
                switch actionItem {
                case _ as ProfileTotalStampMoveAction:
                    self?.coordinator?.pushTotalStampViewModel()
                case _ as ProfileUserEditAction:
                    self?.coordinator?.pushProfileEditViewController()
                case let action as ProfileMenuSelectAction:
                    let menuType = ProfileMenu(rawValue: action.identifier) ?? .wishlist
                    switch menuType {
                    case .wishlist:
                        self?.coordinator?.pushMyWishlistViewController()
                    case .filterViewHistory:
                        self?.coordinator?.pushFilterAccessHistoryViewController()
                    case .writtenReviews:
                        self?.coordinator?.pushMyReviewsViewController()
                    }
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - Request API
extension ProfileViewModel {
    private func requestMyInfomation() {
        usecase?.requestMyInfomation()
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] myInfomationResponse in
                let userInfoModel = ProfileUserInfomationModel(
                    userID: String(myInfomationResponse.userID),
                    userName: myInfomationResponse.userName,
                    profileURLString: myInfomationResponse.profileThumbnailString,
                    stampCount: myInfomationResponse.stampCount,
                    likeCount: myInfomationResponse.likeCount,
                    filterViewCount: myInfomationResponse.filterViewHistoryCount,
                    reviewCount: myInfomationResponse.reviewCount
                )
                self?.userInfomationModel.send(userInfoModel)
            })
            .store(in: &cancellables)
    }
}
