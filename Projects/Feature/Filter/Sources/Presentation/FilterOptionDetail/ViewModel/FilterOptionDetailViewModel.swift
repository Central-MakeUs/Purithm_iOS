//
//  FilterOptionDetailViewModel.swift
//  Filter
//
//  Created by 이숭인 on 8/6/24.
//

import Foundation
import Combine
import CoreUIKit

extension FilterOptionDetailViewModel {
    struct Input {
        let viewWillAppearEvent: AnyPublisher<Bool, Never>
        let closeButtonTapEvent: AnyPublisher<Void, Never>
        let likeButtonTapEvent: AnyPublisher<Void, Never>
    }
    
    struct Output {
        fileprivate let sectionSubject = CurrentValueSubject<[SectionModelType], Never>([])
        var sections: AnyPublisher<[SectionModelType], Never> {
            sectionSubject.compactMap { $0 }.eraseToAnyPublisher()
        }
        
    }
}

final class FilterOptionDetailViewModel {
    weak var coordinator: FilterDetailCoordinator?
    weak var filtersUsecase: FiltersUseCase?
    private let converter = FilterOptionDetailSectionConverter()
    private var cancellables = Set<AnyCancellable>()
    
    private var filterID: String
    
    private let completeLikeEventSubject = PassthroughSubject<String, Never>()
    var completeLikeEventPublusher: AnyPublisher<String, Never> {
        completeLikeEventSubject.eraseToAnyPublisher()
    }
    
    private var contentInfoSubject = CurrentValueSubject<(title: String, isLike: Bool, content: String), Never>(("", false, ""))
    var contentInfoPublisher: AnyPublisher<(title: String, isLike: Bool, content: String), Never> {
        contentInfoSubject.eraseToAnyPublisher()
    }
    private var contentInfo: (title: String, isLike: Bool, content: String) {
        contentInfoSubject.value
    }
    
    init(coordinator: FilterDetailCoordinator, filtersUsecase: FiltersUseCase, filterID: String) {
        self.coordinator = coordinator
        self.filtersUsecase = filtersUsecase
        self.filterID = filterID
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                self?.requestFilterAdjustment(
                    with: self?.filterID ?? "",
                    output: output
                )
            }
            .store(in: &cancellables)
        
        input.closeButtonTapEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.coordinator?.popViewController(animated: false)
            }
            .store(in: &cancellables)
        
        input.likeButtonTapEvent
            .sink { [weak self] _ in
                self?.requestLikeOrUnlike()
            }
            .store(in: &cancellables)
        
        return output
    }
}

//MARK: - API Request
extension FilterOptionDetailViewModel {
    private func requestFilterAdjustment(with filterID: String, output: Output) {
        filtersUsecase?.requestFilterAdjustment(with: filterID)
            .sink { _ in } receiveValue: { [weak self] response in
                let options = response.value.convertModel()
                let sections = self?.converter.createSections(options: options) ?? []
                output.sectionSubject.send(sections)

                self?.contentInfoSubject.send((title: response.name, isLike: response.liked, content: response.thumbnail))
            }
            .store(in: &cancellables)
    }
    
    private func requestLikeOrUnlike() {
        contentInfoSubject.value.isLike.toggle()
        
        if contentInfo.isLike {
            filtersUsecase?.requestLike(with: filterID)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
                    self?.completeLikeEventSubject.send("찜 목록에 담겼어요")
                })
                .store(in: &cancellables)
        } else {
            filtersUsecase?.requestUnlike(with: filterID)
                .sink(receiveCompletion: { _ in }, receiveValue: { _ in
                })
                .store(in: &cancellables)
        }
        
    }
}
