//
//  ReviewViewModel.swift
//  Review
//
//  Created by 이숭인 on 8/9/24.
//

import UIKit
import Combine
import CoreUIKit

extension ReviewViewModel {
    struct Input {
        let viewWillAppearEvent: AnyPublisher<Bool, Never>
        let adapterActionEvent: AnyPublisher<ActionEventItem, Never>
    }
    
    struct Output {
        fileprivate let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
        var sections: AnyPublisher<[SectionModelType], Never> {
            sectionItems.eraseToAnyPublisher()
        }
        
        fileprivate let galleryOpenEvent = PassthroughSubject<Void, Never>()
        var galleryOpenEventPublisher: AnyPublisher<Void, Never> {
            galleryOpenEvent.eraseToAnyPublisher()
        }
    }
}

public final class ReviewViewModel {
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: ReviewCoordinatorable?
    private let converter = ReviewSectionConverter()
    
    // 선택된 이미지 저장 Subject
    var didFinishPickingImageSubject = PassthroughSubject<UIImage, Never>()
    
    private var headerModel = CurrentValueSubject<ReviewHeaderComponentModel, Never>(
        ReviewHeaderComponentModel(
            identifier: UUID().uuidString,
            title: "How Purithm?",
            description: "아래 바를 조절해 만족도를 남겨주세요.",
            thumbnailURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            satisfactionLevel: .none,
            intensity: .zero
        )
    )
    private var intensitySubject = CurrentValueSubject<CGFloat, Never>(.zero)
    private var willUploadImages = CurrentValueSubject<[ReviewUploadImageContainerComponentModel], Never>([
        ReviewUploadImageContainerComponentModel(
            identifier: UUID().uuidString,
            selectedImage: nil
        )
    ])
    
    public init(coordinator: ReviewCoordinatorable) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        bind(output: output)
        
        handleViewWillAppearEvent(input: input, output: output)
        handleAdapterActionEvent(input: input, output: output)
        
        return output
    }
    
    private func bind(output: Output) {
        headerModel
            .compactMap { $0 }
            .sink { [weak self] model in
                guard let self else { return }
                
                let sections = self.converter.createSections(
                    headerModel: model,
                    willUploadImageModels: self.willUploadImages.value)
                
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
        
        willUploadImages
            .sink { [weak self] uploadImageModels in
                guard let self else { return }
                
                let sections = self.converter.createSections(
                    headerModel: self.headerModel.value,
                    willUploadImageModels: uploadImageModels)
                
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
        
        didFinishPickingImageSubject
            .sink { [weak self] selectedImage in
                guard let self else { return }
                
                let uploadImageCount = self.willUploadImages.value.count
                
                if uploadImageCount <= 2 {
                    let willUploadImageItem = ReviewUploadImageContainerComponentModel(
                        identifier: UUID().uuidString,
                        selectedImage: selectedImage
                    )
                    self.willUploadImages.value.insert(willUploadImageItem, at: .zero)
                } else {
                    guard self.willUploadImages.value[safe: 2] != nil else { return }
                    
                    self.willUploadImages.value[2].selectedImage = selectedImage
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - Handler
extension ReviewViewModel {
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                self?.setupHeader()
            }
            .store(in: &cancellables)
    }
    
    private func setupHeader() {
        let model = ReviewHeaderComponentModel(
            identifier: UUID().uuidString,
            title: "How Purithm?",
            description: "아래 바를 조절해 만족도를 남겨주세요.",
            thumbnailURLString: "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
            satisfactionLevel: .none,
            intensity: .zero
        )
        
        headerModel.send(model)
    }
}

extension ReviewViewModel {
    private func handleAdapterActionEvent(input: Input, output: Output) {
        input.adapterActionEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] actionItem in
                guard let self else { return }
                
                switch actionItem {
                case let action as ReviewSliderAction:
                    headerModel.value.updateIntensity(with: action.intensity)
                case let action as ReviewUploadImageAction:
                    output.galleryOpenEvent.send(Void())
                case let action as ReviewCancelUploadImageAction:
                    //TODO: id 찾아서 해당 컴포넌트 제거하기
                    if let targetIndex = self.willUploadImages.value.firstIndex(where: { $0.identifier == action.identifier }) {
                        
                        guard self.willUploadImages.value[safe: targetIndex] != nil else {
                            return
                        }
                        
                        self.willUploadImages.value[targetIndex].selectedImage = nil
                    }
                    break
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func findSectionItem(with identifier: String) {
        
    }
}
