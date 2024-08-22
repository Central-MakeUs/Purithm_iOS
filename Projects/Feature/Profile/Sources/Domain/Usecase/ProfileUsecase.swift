//
//  ProfileUsecase.swift
//  Profile
//
//  Created by 이숭인 on 8/21/24.
//

import Foundation
import Combine
import CoreCommonKit
import CombineExt

public final class ProfileUsecase {
    private var cancellables = Set<AnyCancellable>()
    
    private let profileService: ProfileServiceManageable
    
    public init(profileService: ProfileServiceManageable) {
        self.profileService = profileService
    }
    
    public func requestMyInfomation() -> AnyPublisher<ProfileMyInformationResponseDTO, Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            let publisher = profileService.requestMyInfomation()
                .share()
                .materialize()
            
            publisher.values()
                .sink { response in
                    guard let data = response.data else { return }
                    return promise(.success(data))
                }
                .store(in: &cancellables)
            
            publisher.failures()
                .sink { error in
                    return promise(.failure(error))
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    public func requestAccountInfomation() -> AnyPublisher<ProfileAccountInfomationResponseDTO, Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            let publisher = profileService.requestAccountInfomation()
                .share()
                .materialize()
            
            publisher.values()
                .sink { response in
                    guard let data = response.data else { return }
                    return promise(.success(data))
                }
                .store(in: &cancellables)
            
            publisher.failures()
                .sink { error in
                    return promise(.failure(error))
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    public func requestStampInfomation() -> AnyPublisher<ProfileStamInfomationResponseDTO, Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            let publisher = profileService.requestStampInfomation()
                .share()
                .materialize()
            
            publisher.values()
                .sink { response in
                    guard let data = response.data else { return }
                    return promise(.success(data))
                }
                .store(in: &cancellables)
            
            publisher.failures()
                .sink { error in
                    return promise(.failure(error))
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    public func requestPrepareUpload() -> AnyPublisher<PrepareUploadResponseDTO, Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            let publisher = profileService.requestPrepareUploadURL()
                .share()
                .materialize()
            
            publisher.values()
                .sink { response in
                    guard let data = response.data else { return }
                    return promise(.success(data))
                }
                .store(in: &cancellables)
            
            publisher.failures()
                .sink { error in
                    return promise(.failure(error))
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    public func requestUploadImage(urlString: String, imageData: Data) -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            let publisher = profileService.requestUploadImage(
                urlString: urlString,
                imageData: imageData
            )
                .share()
                .materialize()
            
            publisher.values()
                .sink { response in
                    return promise(.success(response))
                }
                .store(in: &cancellables)
            
            publisher.failures()
                .sink { error in
                    return promise(.failure(error))
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    public func requestEditMyInfomation(parameter: ProfileEditRequestDTO) -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            let publisher = profileService.requestEditMyInfomation(parameter: parameter)
                .share()
                .materialize()
            
            publisher.values()
                .sink { response in
                    return promise(.success(()))
                }
                .store(in: &cancellables)
            
            publisher.failures()
                .sink { error in
                    return promise(.failure(error))
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
}
