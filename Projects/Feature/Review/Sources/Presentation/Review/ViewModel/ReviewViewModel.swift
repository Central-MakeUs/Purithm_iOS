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
    weak var usecase: ReviewUsecase?
    private let filterID: String
    
    private let converter = ReviewSectionConverter()
    
    private let requestDTO: CurrentValueSubject<ReviewCreateRequestDTO, Never>
    
    // 선택된 이미지 저장 Subject
    var didFinishPickingImageSubject = PassthroughSubject<UIImage, Never>()
    var selectedImageComponentIdentifier = CurrentValueSubject<String, Never>("")
    
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
            selectedImage: nil,
            isUploadContinue: false
        )
    ])
    private let isUploadState = CurrentValueSubject<[String: Bool], Never>([:]) //Identifier : uploadState
    
    /// 각 컴포넌트의 id: url
    var willUploadURLString: [String: String] = [:] // identifier: url
    
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
    
    public init(
        coordinator: ReviewCoordinatorable,
        usecase: ReviewUsecase,
        filterID: String
    ) {
        self.coordinator = coordinator
        self.usecase = usecase
        self.filterID = filterID
        
        let initalizedDTO = ReviewCreateRequestDTO(
            filterID: filterID,
            satisfactionValue: 0,
            description: "",
            uploadedURLStrings: []
        )
        requestDTO = CurrentValueSubject<ReviewCreateRequestDTO, Never>(initalizedDTO)
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        bind(output: output)
        
        handleConformState(input: input)
        handleConformActionEvent(input: input, output: output)
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
                
                requestDTO.value.satisfactionValue = Int(model.intensity)
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
            .compactMap { [weak self] image -> (identifier: String, image: UIImage)? in
                guard let identifier = self?.selectedImageComponentIdentifier.value,
                      !identifier.isEmpty else {
                    return nil
                }
                if let urlString = self?.willUploadURLString[identifier], !urlString.isEmpty {
                    self?.requestUploadImage(
                        identifier: identifier,
                        urlString: urlString,
                        image: image
                    )
                }
                
                return (identifier, image)
            }
            .sink { [weak self] selectedInfo in
                guard let self else { return }
                guard let targetIndex = self.willUploadImages.value.firstIndex(where: { $0.identifier == selectedInfo.identifier }) else {
                    return
                }
                
                let isEmptyComponent = self.willUploadImages.value[targetIndex].selectedImage == nil
                let isMaxLenght = !(self.willUploadImages.value.count <= 2)

                self.willUploadImages.value[targetIndex].selectedImage = selectedInfo.image
                
                if !isMaxLenght && isEmptyComponent  {
                    let willUploadImageItem = ReviewUploadImageContainerComponentModel(
                        identifier: UUID().uuidString,
                        selectedImage: nil,
                        isUploadContinue: false
                    )
                    self.willUploadImages.value.append(willUploadImageItem)
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
                self?.requestFilterInfo()
            }
            .store(in: &cancellables)
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
                case let action as ReviewTextViewAction:
                    requestDTO.value.description = action.text
                case let action as ReviewSliderAction:
                    headerModel.value.updateIntensity(with: action.intensity)
                case let action as ReviewUploadImageAction:
                    self.requestPrepareUploadReview(with: action.identifier)
                    self.selectedImageComponentIdentifier.send(action.identifier)
                    output.galleryOpenEvent.send(Void())
                case let action as ReviewCancelUploadImageAction:
                    // 삭제한 이미지를 담고있는 컴포넌트의 id, url을 삭제
                    self.willUploadURLString.removeValue(forKey: action.identifier)
                    
                    if let targetIndex = self.willUploadImages.value.firstIndex(where: { $0.identifier == action.identifier }) {
                        guard self.willUploadImages.value[safe: targetIndex] != nil else {
                            return
                        }
                        
                        self.willUploadImages.value.remove(at: targetIndex)
                        
                        let isContainEmptyComponent = self.willUploadImages.value.contains { $0.selectedImage == nil }
                        if !isContainEmptyComponent {
                            let willUploadImageItem = ReviewUploadImageContainerComponentModel(
                                identifier: UUID().uuidString,
                                selectedImage: nil, 
                                isUploadContinue: false
                            )
                            self.willUploadImages.value.append(willUploadImageItem)
                        }
                    }
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
                self?.requestCreateReview()
            }
            .store(in: &cancellables)
    }
    
    private func handleConformState(input: Input) {
        let textChangeActionEventPublisher = input.adapterActionEvent
            .compactMap { $0 as? ReviewTextViewAction }
            .eraseToAnyPublisher()
        let contentConformStatePublisher = Publishers.CombineLatest4(
            headerModel,
            willUploadImages,
            termsItems,
            textChangeActionEventPublisher
        )
        
        Publishers.CombineLatest(contentConformStatePublisher,isUploadState)
            .map { contentConformState, uploadState -> (header: ReviewHeaderComponentModel, willUploadImages: [ReviewUploadImageContainerComponentModel], termsItems: [ReviewTermsItemComponentModel], text: String, isUploadState: [String: Bool]) in
                
                return (contentConformState.0, contentConformState.1, contentConformState.2, contentConformState.3.text, uploadState)
            }
            .map { contentConformState in

                let termsAllAgree = !contentConformState.termsItems.contains { !$0.isSelected }
                let isSetIntensity = contentConformState.header.intensity >= 20
                let isSetTextCount = contentConformState.text.count >= 20
                let isUploaded = contentConformState.willUploadImages.filter { $0.selectedImage != nil }.count >= 1
                let isUploadContinue = !Array(contentConformState.isUploadState.values).contains(false)
                
                return termsAllAgree && isSetIntensity && isSetTextCount && isUploaded && isUploadContinue
            }
            .sink { [weak self] isEnabled in
                self?.conformState.send(isEnabled)
            }
            .store(in: &cancellables)
    }
}

extension ReviewViewModel {
    private func requestFilterInfo() {
        usecase?.requestFilterInfo(with: filterID)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                let model = ReviewHeaderComponentModel(
                    identifier: UUID().uuidString,
                    title: "How Purithm?",
                    description: "아래 바를 조절해 만족도를 남겨주세요.",
                    thumbnailURLString: response.thumbnail,
                    satisfactionLevel: .none,
                    intensity: .zero
                )
                
                self?.headerModel.send(model)
            })
            .store(in: &cancellables)
    }
    
    private func requestCreateReview() {
        requestDTO.value.uploadedURLStrings = Array(willUploadURLString.values).filter { !$0.isEmpty }
        usecase?.requestCreateReview(with: requestDTO.value)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                let reviewID = String(response.reviewID)
                self?.coordinator?.presentCompleteAlert(with: reviewID)
            })
            .store(in: &cancellables)
    }
    
    private func requestPrepareUploadReview(with identifier: String) {
        usecase?.requestPrepareUpload()
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                self?.willUploadURLString[identifier] = response.url
            })
            .store(in: &cancellables)
    }
    
    private func requestUploadImage(identifier: String, urlString: String, image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) ?? image.pngData() else {
            print("Error converting image to Data")
            return
        }
        
        if let targetIndex = willUploadImages.value.firstIndex(where: { $0.identifier == identifier }) {
            willUploadImages.value[targetIndex].isUploadContinue = true
            isUploadState.value[identifier] = false
        }
        
        usecase?.requestUploadImage(urlString: urlString, imageData: imageData)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] url in
                // 업로드 성공 이후, 쿼리파라미터를 제거한 url을 requestDTO에 추가
                let baseURL = String(urlString.split(separator: "?", maxSplits: 1, omittingEmptySubsequences: true).first ?? "")
                self?.willUploadURLString.updateValue(baseURL, forKey: identifier)
                
                //TODO: 2. 업로드 끝 - 인디케이터 끄기, 올리기 버튼 활성화
                if let targetIndex = self?.willUploadImages.value.firstIndex(where: { $0.identifier == identifier }) {
                    self?.willUploadImages.value[targetIndex].isUploadContinue = false
                    self?.isUploadState.value.removeValue(forKey: identifier)
                }
            })
            .store(in: &cancellables)
    }
}
