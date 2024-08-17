//
//  FilterDetailViewModel.swift
//  Filter
//
//  Created by 이숭인 on 7/30/24.
//

import Foundation
import Combine
import CoreUIKit
import Kingfisher

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
        let headerInfo = PassthroughSubject<FilterDetailModel, Never>()
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
    
    private func prefetchDetailImagesIfNeeded(with detailImages: [FilterDetailModel.DetailImageModel]) {
        detailImages.forEach { detailImage in
            if let edited = URL(string: detailImage.imageURLString),
               let original = URL(string: detailImage.originalImageURLString) {
                ImagePrefetcher(urls: [edited, original]).start()
            }
        }
    }
    
    deinit {
        print("detail viewmOdel")
    }
}

//MARK: - Handle Events
extension FilterDetailViewModel {
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        requestFilterDetail(with: filterID)
    }

    private func handleFilterDetailChangeEvent(output: Output) {
        filterDetail
            .compactMap { $0 }
            .sink { [weak self] detail in
                if let sections = self?.converter.createSections(with: detail) {
                    self?.prefetchDetailImagesIfNeeded(with: detail.detailImages)
                    
                    output.sections.send(sections)
                    output.headerInfo.send(detail)
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
            .sink { [weak self] _ in
                guard let filterID = self?.filterID else {
                    return
                }
                
                self?.filterDetail.value?.detailInformation.isLike.toggle()
                let isLike = self?.filterDetail.value?.detailInformation.isLike ?? false
                
                if isLike {
                    self?.filterDetail.value?.detailInformation.likeCount += 1
                    self?.requestFilterLike(with: filterID)
                } else {
                    self?.filterDetail.value?.detailInformation.likeCount -= 1
                    self?.requestFilterUnlike(with: filterID)
                }
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
                    self?.coordinator?.pushFilterReviews(with: self?.filterID ?? "")
                    break
                case .introduction:
                    self?.coordinator?.pushFilterDescription(with: self?.filterID ?? "")
                }
            }
            .store(in: &cancellabels)
    }
    
    private func handleShowOriginalEvent(input: Input, output: Output) {
        input.showOriginalTapEvent
            .sink { [weak self] _ in
                print("handleShowOriginalEvent")
                self?.filterDetail.value?.isShowOriginal = false
            }
            .store(in: &cancellabels)
        input.showOriginalPressedEvent
            .sink { [weak self] _ in
                print("showOriginalPressedEvent")
                self?.filterDetail.value?.isShowOriginal = true
            }
            .store(in: &cancellabels)
    }
    
    private func handleConformEvent(input: Input, output: Output) {
        input.conformEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.coordinator?.pushFilterOptionDetail(with: self?.filterID ?? "")
            }
            .store(in: &cancellabels)
    }
}

//MARK: - API Request
extension FilterDetailViewModel {
    private func requestFilterDetail(with filterID: String) {
        usecase.requestFilterDetail(with: filterID)
            .sink { _ in } receiveValue: { [weak self] response in
                let detailModel = response.convertModel()
                self?.filterDetail.send(detailModel)
            }
            .store(in: &cancellabels)
    }
    
    private func requestFilterLike(with filterID: String) {
        usecase.requestLike(with: filterID)
            .sink { _ in } receiveValue: { [weak self] _ in
                //TODO: 토스트 띄우기
                print("//TODO: like 토스트 띄우기")
            }
            .store(in: &cancellabels)
    }
    
    private func requestFilterUnlike(with filterID: String) {
        usecase.requestUnlike(with: filterID)
            .sink { _ in } receiveValue: { [weak self] _ in
                //TODO: 토스트 띄우기
                print("//TODO: unlike 토스트 띄우기")
            }
            .store(in: &cancellabels)
    }
}
