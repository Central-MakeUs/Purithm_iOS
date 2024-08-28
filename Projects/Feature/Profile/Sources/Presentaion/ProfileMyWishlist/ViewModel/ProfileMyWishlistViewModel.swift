//
//  ProfileMyWishilistViewModel.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import Foundation
import Combine
import CoreCommonKit
import CoreUIKit
import UIKit

extension ProfileMyWishlistViewModel {
    struct Input {
        let viewWillAppearEvent: AnyPublisher<Bool, Never>
        let adapterActionEvent: AnyPublisher<ActionEventItem, Never>
    }
    
    struct Output {
        fileprivate let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
        var sections: AnyPublisher<[SectionModelType], Never> {
            sectionItems.eraseToAnyPublisher()
        }
        
        let conformAlertPresentEvent = PassthroughSubject<Void, Never>()
        
        fileprivate let sectionEmptySubject = PassthroughSubject<Bool, Never>()
        var sectionEmptyPublisher: AnyPublisher<Bool, Never> {
            sectionEmptySubject.eraseToAnyPublisher()
        }
        
        fileprivate let presentFilterRockBottomSheetSubject = PassthroughSubject<Void, Never>()
        var presentFilterRockBottomSheetEvent: AnyPublisher<Void, Never> {
            presentFilterRockBottomSheetSubject.eraseToAnyPublisher()
        }
    }
}

final class ProfileMyWishlistViewModel {
    weak var coordinator: ProfileCoordinatorable?
    weak var usecase: ProfileUsecase?
    
    private let converter = ProfileMyWishlistSectionConverter()
    private var cancellables = Set<AnyCancellable>()
    
    private let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
    
    private var filtersSubject = CurrentValueSubject<[FilterItemModel], Never>([])
    
    init(coordinator: ProfileCoordinatorable, usecase: ProfileUsecase) {
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
        
        filtersSubject
            .sink { [weak self] filters in
                guard let self else { return }
                let sections = self.converter.createSections(
                    filters: filters
                )
                
                self.sectionItems.send(sections)
                output.sectionEmptySubject.send(filters.isEmpty)
            }
            .store(in: &cancellables)
    }
}

//MARK: - Handle View Will Appear Event
extension ProfileMyWishlistViewModel {
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                self?.requestMyWishlist()
            }
            .store(in: &cancellables)
    }
}

//MARK: Handle Action Event
extension ProfileMyWishlistViewModel {
    private func handleAdapterActionEvent(input: Input, output: Output) {
        input.adapterActionEvent
            .sink { [weak self] actionItem in
                guard let self else { return }
                
                switch actionItem {
                case let action as FilterLikeAction:
                    var filters = self.filtersSubject.value
                    
                    if let targetIndex = filters.firstIndex(where: { $0.identifier == action.identifier }) {
                        filters[targetIndex].isLike.toggle()
                        
                        if filters[targetIndex].isLike {
                            filters[targetIndex].likeCount += 1
                            self.requestLike(with: action.identifier)
                        } else {
                            filters[targetIndex].likeCount -= 1
                            self.requestUnlike(with: action.identifier)
                        }
                        
                        self.filtersSubject.send(filters)
                    }
                case let action as FilterDidTapAction:
                    let filters = self.filtersSubject.value
                    
                    if let targetIndex = filters.firstIndex(where: { $0.identifier == action.identifier }) {
                        if filters[targetIndex].canAccess {
                            self.coordinator?.pushFilterDetail(with: action.identifier)
                        } else {
                            output.presentFilterRockBottomSheetSubject.send(Void())
                        }
                    }
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - API Request
extension ProfileMyWishlistViewModel {
    private func requestMyWishlist() {
        usecase?.requestMyWishlist()
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                let filters = response.map { item in
                    let itemModel = FilterItemModel(
                        identifier: "\(item.id)", 
                        filterID: "\(item.id)",
                        filterImageURLString: item.thumbnail,
                        planType: PlanType.calculatePlanType(with: item.membership),
                        filterTitle: item.name,
                        author: item.photographerName,
                        authorID: "",
                        isLike: true,
                        likeCount: item.likes,
                        canAccess: item.canAccess
                    )
                    return itemModel
                }
                
                self?.filtersSubject.send(filters)
            })
            .store(in: &cancellables)
    }
    
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
}
