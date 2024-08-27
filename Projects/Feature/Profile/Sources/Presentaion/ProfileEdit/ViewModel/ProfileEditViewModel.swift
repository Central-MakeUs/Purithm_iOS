//
//  ProfileEditViewModel.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import Foundation
import Combine
import CoreCommonKit
import CoreUIKit
import UIKit

extension ProfileEditViewModel {
    struct Input {
        let viewWillAppearEvent: AnyPublisher<Bool, Never>
        let adapterActionEvent: AnyPublisher<ActionEventItem, Never>
    }
    
    struct Output {
        fileprivate let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
        var sections: AnyPublisher<[SectionModelType], Never> {
            sectionItems.eraseToAnyPublisher()
        }

        fileprivate let optionPresentEventSubject = PassthroughSubject<Void, Never>()
        var optionPresentEventPublisher: AnyPublisher<Void, Never> {
            optionPresentEventSubject.eraseToAnyPublisher()
        }
    }
}

final class ProfileEditViewModel {
    weak var coordinator: ProfileCoordinatorable?
    weak var usecase: ProfileUsecase?
    
    private let converter = ProfileEditSectionConverter()
    private var cancellables = Set<AnyCancellable>()
    
    private let sectionItems = CurrentValueSubject<[SectionModelType], Never>([])
    
    private let userInfomationModel = CurrentValueSubject<ProfileUserInfomationModel?, Never>(nil)
    
    var didFinishPickingImageSubject = PassthroughSubject<UIImage, Never>()
    
    init(coordinator: ProfileCoordinatorable, usecase: ProfileUsecase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }
    
    private var willEditName: String = ""
    private var willUploadImageURLString: String = ""
    private var isUploadState = CurrentValueSubject<Bool, Never>(false)
    
    private let uploadInProgressErrorSubject = PassthroughSubject<Void, Never>()
    var uploadInProgressErrorPublisher: AnyPublisher<Void, Never> {
        uploadInProgressErrorSubject.eraseToAnyPublisher()
    }
    
    private let editCompletSubject = PassthroughSubject<Void, Never>()
    var editCompletPublisher: AnyPublisher<Void, Never> {
        editCompletSubject.eraseToAnyPublisher()
    }
    
    private var orderOptionModels = CurrentValueSubject<[ProfileEditOptionModel], Never>([])
    var orderOptions: [ProfileEditOptionModel] {
        orderOptionModels.value
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
        
        userInfomationModel
            .compactMap { $0 }
            .sink { [weak self] profileModel in
                guard let self else { return }
                self.willEditName = profileModel.userName
                self.willUploadImageURLString = profileModel.profileURLString
                
                let sections = self.converter.createSections(
                    name: profileModel.userName,
                    thumbnail: profileModel.profileURLString,
                    isUploadState: self.isUploadState.value
                )
                
                self.sectionItems.send(sections)
            }
            .store(in: &cancellables)
        
        didFinishPickingImageSubject
            .sink { [weak self] image in
                guard let self else { return }
                //1. 업로드하기 urlstring, image
                let url = self.willUploadImageURLString
                self.requestUploadImage(
                    urlString: url,
                    image: image
                )
            }
            .store(in: &cancellables)
        
        isUploadState
            .dropFirst()
            .sink { [weak self] isUploadState in
                guard let self else { return }
                
                let sections = self.converter.createSections(
                    name: self.userInfomationModel.value?.userName ?? "",
                    thumbnail: self.willUploadImageURLString,
                    isUploadState: isUploadState
                )
                
                self.sectionItems.send(sections)
            }
            .store(in: &cancellables)
    }
    
    private func setupOrderOption() {
        let orderOptions = ProfileEditOption.allCases.map { option in
            ProfileEditOptionModel(
                identifier: option.identifier,
                option: option,
                isSelected: true)
        }
        
        orderOptionModels.send(orderOptions)
    }
    
    func requestEditProfile() {
        if isUploadState.value {
            uploadInProgressErrorSubject.send(())
        } else {
            if willEditName.count >= 4 {
                requestEditInfomation()
            }
        }
    }
    
    func resetProfileToDefault() {
        willUploadImageURLString = ""
        
        let profileModel = userInfomationModel.value
        let sections = converter.createSections(
            name: profileModel?.userName ?? "",
            thumbnail: "",
            isUploadState: false
        )
        
        self.sectionItems.send(sections)
    }
}

//MARK: - Handle View Will Appear Event
extension ProfileEditViewModel {
    private func handleViewWillAppearEvent(input: Input, output: Output) {
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                self?.setupOrderOption()
                self?.requestMyInfomation()
            }
            .store(in: &cancellables)
    }
}

//MARK: Handle Action Event
extension ProfileEditViewModel {
    private func handleAdapterActionEvent(input: Input, output: Output) {
        input.adapterActionEvent
            .sink { [weak self] actionItem in
                switch actionItem {
                case _ as ProfileEditImageAction:
                    self?.requestPrepareUploadReview()
                    output.optionPresentEventSubject.send(())
                case let action as ProfileEditViewAction:
                    self?.willEditName = action.text
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

extension ProfileEditViewModel {
    private func requestMyInfomation() {
        usecase?.requestMyInfomation()
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] myInfomationResponse in
                let userInfoModel = ProfileUserInfomationModel(
                    userID: String(myInfomationResponse.userID),
                    userName: myInfomationResponse.userName,
                    profileURLString: myInfomationResponse.profileThumbnailString,
                    stampCount: myInfomationResponse.stampCount,
                    likeCount: myInfomationResponse.likeCount,
                    filterViewCount: myInfomationResponse.filterViewHistoryCount,
                    reviewCount: myInfomationResponse.reviewCount
                )
                self?.userInfomationModel.send(userInfoModel)
            })
            .store(in: &cancellables)
    }
    
    private func requestPrepareUploadReview() {
        usecase?.requestPrepareUpload()
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                self?.willUploadImageURLString = response.url
            })
            .store(in: &cancellables)
    }
    
    private func requestUploadImage(urlString: String, image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) ?? image.pngData() else {
            print("Error converting image to Data")
            return
        }
        
        isUploadState.send(true)
        usecase?.requestUploadImage(urlString: urlString, imageData: imageData)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] url in
                guard let self else { return }
                // 업로드 성공 이후, 쿼리파라미터를 제거한 url을 requestDTO에 추가
                let baseURL = String(urlString.split(separator: "?", maxSplits: 1, omittingEmptySubsequences: true).first ?? "")
                self.willUploadImageURLString = baseURL
                
                self.isUploadState.send(false)
            })
            .store(in: &cancellables)
    }
    
    private func requestEditInfomation() {
        let parameter = ProfileEditRequestDTO(
            name: willEditName,
            profile: willUploadImageURLString
        )
        usecase?.requestEditMyInfomation(parameter: parameter)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
                self?.editCompletSubject.send(())
            })
            .store(in: &cancellables)
    }
}
