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
    weak var coordinator: FiltersCoordinatorable?
    weak var filtersUsecase: FiltersUseCase?
    private let converter = FilterOptionDetailSectionConverter()
    
    private var cancellables = Set<AnyCancellable>()
    
    // only test
    private var options: [FilterOptionModel] = IPhonePhotoFilter.allCases.map { type in
        FilterOptionModel(
            identifier: UUID().uuidString,
            optionType: type,
            intensity: 10
        )
    }
    
    
    init(coordinator: FiltersCoordinatorable, filtersUsecase: FiltersUseCase) {
        self.coordinator = coordinator
        self.filtersUsecase = filtersUsecase
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.closeButtonTapEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.coordinator?.popViewController(animated: false)
            }
            .store(in: &cancellables)
        
        input.likeButtonTapEvent
            .sink { [weak self] _ in
                print("::: like button")
            }
            .store(in: &cancellables)
        
        let sections = converter.createSections(options: options)
        output.sectionSubject.send(sections)
        
        return output
    }
}
