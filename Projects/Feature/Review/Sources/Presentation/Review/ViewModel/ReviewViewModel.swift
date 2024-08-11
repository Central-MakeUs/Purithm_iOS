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
        let conformButtonTapEvent: AnyPublisher<Void, Never>
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
        
        var conformStateSubject = CurrentValueSubject<Bool, Never>(false)
        var conformStatePublisher: AnyPublisher<Bool, Never> {
            conformStateSubject.eraseToAnyPublisher()
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
    
    private var termsItems = CurrentValueSubject<[ReviewTermsItemComponentModel], Never>(
        ReviewTerms.allCases.map { term in
            ReviewTermsItemComponentModel(
                identifier: UUID().uuidString,
                termsItem: term,
                isSelected: false
            )
        }
    )
    
    //TODO: 추후 서버에 요청할 도메인 모델로 사용할 거임.. 일단 변수로 두자
    private var conformState = CurrentValueSubject<Bool, Never>(false)
    
    public init(coordinator: ReviewCoordinatorable) {
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        bind(output: output)
        
        handleConformState(input: input)
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
                    willUploadImageModels: self.willUploadImages.value,
                    termsItemModels: self.termsItems.value
                    )
                
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
        
        willUploadImages
            .sink { [weak self] uploadImageModels in
                guard let self else { return }
                
                let sections = self.converter.createSections(
                    headerModel: self.headerModel.value,
                    willUploadImageModels: uploadImageModels, 
                    termsItemModels: self.termsItems.value
                )
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
        
        termsItems
            .sink { [weak self] termsItems in
                guard let self else { return }
                
                let sections = self.converter.createSections(
                    headerModel: self.headerModel.value,
                    willUploadImageModels: self.willUploadImages.value,
                    termsItemModels: self.termsItems.value
                )
                
                output.sectionItems.send(sections)
            }
            .store(in: &cancellables)
        
        conformState
            .sink { isEnabled in
                output.conformStateSubject.send(isEnabled)
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

//MARK: Handle Adapter Action
extension ReviewViewModel {
    private func handleAdapterActionEvent(input: Input, output: Output) {
        input.adapterActionEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] actionItem in
                guard let self else { return }
                
                switch actionItem {
                case let action as ReviewSliderAction:
                    headerModel.value.updateIntensity(with: action.intensity)
                case _ as ReviewUploadImageAction:
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
                case let action as ReviewTermsItemAction:
                    if let targetIndex = self.termsItems.value.firstIndex(where: { $0.identifier == action.identifier }) {
                        self.termsItems.value[targetIndex].isSelected.toggle()
                    }
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: Handle Conform State
extension ReviewViewModel {
    private func handleConformActionEvent(input: Input, output: Output) {
        input.conformButtonTapEvent
            .sink { [weak self] _ in
                //TODO: 필더 후기 작성 API Request
            }
            .store(in: &cancellables)
    }
    
    private func handleConformState(input: Input) {
        let textChangeActionEventPublisher = input.adapterActionEvent
            .compactMap { $0 as? ReviewTextViewAction }
            .eraseToAnyPublisher()
        
        Publishers.CombineLatest(termsItems, textChangeActionEventPublisher)
            .map { termsItems, action in
                let termsAllAgree = !termsItems.contains { !$0.isSelected }
                return action.text.count >= 20 && termsAllAgree
            }
            .sink { [weak self] isEnabled in
                self?.conformState.send(isEnabled)
            }
            .store(in: &cancellables)
    }
}
