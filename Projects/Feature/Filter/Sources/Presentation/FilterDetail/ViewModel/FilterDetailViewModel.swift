//
//  FilterDetailViewModel.swift
//  Filter
//
//  Created by 이숭인 on 7/30/24.
//

import Foundation
import Combine
import CoreUIKit

extension FilterDetailViewModel {
    struct Input {
        let viewWillAppearEvent: AnyPublisher<Bool, Never>
        let pageBackEvent: AnyPublisher<Void, Never>
        let filterLikeEvent: AnyPublisher<Void, Never>
        let filterMoreOptionEvent: AnyPublisher<FilterDetailOptionType?, Never>
        let showOriginalTapEvent: AnyPublisher<Void, Never>
        let showOriginalPressedEvent: AnyPublisher<Void, Never>
        let conformEvent: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let sections = CurrentValueSubject<[SectionModelType], Never>([])
    }
}

final class FilterDetailViewModel {
    private var cancellabels = Set<AnyCancellable>()
    weak var coordinator: FilterDetailCoordinatorable?
    private let usecase: FiltersUseCase
    
    private let converter = FilterDetailSectionConverter()
    
    private var filterID: String
    private var filterDetail = CurrentValueSubject<FilterDetailModel?, Never>(nil)
    var filter: FilterDetailModel? {
        filterDetail.value
    }
    
    init(with filterID: String, coordinator: FilterDetailCoordinatorable, usecase: FiltersUseCase) {
        self.filterID = filterID
        self.coordinator = coordinator
        self.usecase = usecase
    }

    func transform(input: Input) -> Output{
        let output = Output()
        
        handleFilterDetailChangeEvent(output: output)
        handleViewWillAppearEvent(input: input, output: output)
        handleBackEvent(input: input, output: output)
        handleLikeTapEvent(input: input, output: output)
        handleOptionTapEvent(input: input, output: output)
        handleShowOriginalEvent(input: input, output: output)
        handleConformEvent(input: input, output: output)
        
        return output
    }
}

//MARK: - Handle Events
extension FilterDetailViewModel {
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        usecase.requestFilterDetail(with: filterID)
            .sink { _ in } receiveValue: { [weak self] response in
                let detailModel = response.convertModel()
                self?.filterDetail.send(detailModel)
            }
            .store(in: &cancellabels)
    }

    private func handleFilterDetailChangeEvent(output: Output) {
        filterDetail
            .compactMap { $0 }
            .sink { [weak self] detail in
                if let sections = self?.converter.createSections(with: detail) {
                    output.sections.send(sections)
                }
            }
            .store(in: &cancellabels)
    }
    
    private func handleBackEvent(input: Input, output: Output) {
        input.pageBackEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.coordinator?.popViewController(animated: true)
                self?.coordinator?.finish()
                
            }
            .store(in: &cancellabels)
    }
    
    private func handleLikeTapEvent(input: Input, output: Output) {
        input.filterLikeEvent
            .sink { _ in
                //TODO: like
            }
            .store(in: &cancellabels)
    }
    
    private func handleOptionTapEvent(input: Input, output: Output) {
        input.filterMoreOptionEvent
            .sink { [weak self] optionType in
                guard let optionType else {
                    print(" optionType is nil. ")
                    return
                }
                
                //TODO: filterID주입해줘야함!!
                switch optionType {
                case .satisfaction:
                    self?.coordinator?.pushFilterReviews(with: "filterID")
                    break
                case .introduction:
                    self?.coordinator?.pushFilterDescription(with: "filterID")
                }
            }
            .store(in: &cancellabels)
    }
    
    private func handleShowOriginalEvent(input: Input, output: Output) {
        input.showOriginalTapEvent
            .sink { _ in
                print("handleShowOriginalEvent")
            }
            .store(in: &cancellabels)
        input.showOriginalPressedEvent
            .sink { _ in
                print("showOriginalPressedEvent")
            }
            .store(in: &cancellabels)
    }
    
    private func handleConformEvent(input: Input, output: Output) {
        input.conformEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                //TODO: filterID주입해줘야함!!
                self?.coordinator?.pushFilterOptionDetail(with: "filterID")
            }
            .store(in: &cancellabels)
    }
}
