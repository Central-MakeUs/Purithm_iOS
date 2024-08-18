//
//  FilterDescriptionViewModel.swift
//  Filter
//
//  Created by 이숭인 on 8/3/24.
//

import Combine
import CoreUIKit

extension FilterDescriptionViewModel {
    struct Input {
        let viewWillAppearEvent: AnyPublisher<Bool, Never>
    }
    
    struct Output {
        let descriptionsSubject = PassthroughSubject<FilterDescriptionModel, Never>()
        var descriptions: AnyPublisher<FilterDescriptionModel, Never> {
            descriptionsSubject.compactMap { $0 }.eraseToAnyPublisher()
        }
    }
}

final class FilterDescriptionViewModel {
    private weak var filtersUsecase: FiltersUseCase?
    private var cancellables = Set<AnyCancellable>()
    private let filterID: String
    private var descriptionModel = CurrentValueSubject<FilterDescriptionModel?, Never>(nil)
    
    init(filterID: String, useCase: FiltersUseCase) {
        self.filterID = filterID
        self.filtersUsecase = useCase
    }
    
    func transform(from input: Input) -> Output {
        let output = Output()
        
        bind(output: output)
        handleViewWillAppearEvent(input: input, output: output)
        
        return output
    }
    
    private func bind(output: Output) {
        descriptionModel
            .compactMap { $0 }
            .sink { model in
                output.descriptionsSubject.send(model)
            }
            .store(in: &cancellables)
    }
    
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.filtersUsecase?.requestFilterDescription(with: self.filterID)
                    .sink(receiveCompletion: { _ in }, receiveValue: { response in
                        let convertedResponse = response.convertModel()
                        self.descriptionModel.send(convertedResponse)
                    })
                    .store(in: &cancellables)
            }
            .store(in: &cancellables)
    }
}
