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
        let showOriginalEvent: AnyPublisher<Void, Never>
        let conformEvent: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let sections = CurrentValueSubject<[SectionModelType], Never>([])
    }
}

final class FilterDetailViewModel {
    private var cancellabels = Set<AnyCancellable>()
    weak var coordinator: FiltersCoordinatorable?
    private let converter = FilterDetailSectionConverter()
    
    var filterDetail = CurrentValueSubject<FilterDetailModel?, Never>(nil)
    
    init(with filterID: String, coordinator: FiltersCoordinatorable) {
        //TODO: ID 를 기반으로 filter 상세 정보 불러와야함
        self.coordinator = coordinator
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
        let detail = FilterDetailModel(
            detailInformation: FilterDetailModel.DetailInformation(
                title: "BlueMing",
                satisfaction: 80,
                isLike: true,
                likeCount: 12
            ),
            detailImages: [
                FilterDetailModel.DetailImageModel(
                    identifier: UUID().uuidString,
                    imageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0"
                ),
                FilterDetailModel.DetailImageModel(
                    identifier: UUID().uuidString,
                    imageURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0"
                )
            ]
        )
        
        filterDetail.send(detail)
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
                self?.coordinator?.popViewController()
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
                switch optionType {
                case .satisfaction:
                    break
                case .introduction:
                    self?.coordinator?.pushFilterDescription(with: "filterID")
                }
                
                //TODO: Type에 따라 화면 전환
                print("//TODO: Type에 따라 화면 전환 > \(optionType)")
            }
            .store(in: &cancellabels)
    }
    
    private func handleShowOriginalEvent(input: Input, output: Output) {
        input.showOriginalEvent
            .sink { _ in
                print("handleShowOriginalEvent")
            }
            .store(in: &cancellabels)
    }
    
    private func handleConformEvent(input: Input, output: Output) {
        input.conformEvent
            .sink { _ in
                print("handleConformEvent")
            }
            .store(in: &cancellabels)
    }
}
