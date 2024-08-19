//
//  ReviewUsecase.swift
//  Review
//
//  Created by 이숭인 on 8/18/24.
//

import Foundation
import Combine
import CoreCommonKit
import CombineExt

public final class ReviewUsecase {
    private var cancellables = Set<AnyCancellable>()
    
    private let reviewService: ReviewServiceManageable
    
    public init(reviewService: ReviewServiceManageable) {
        self.reviewService = reviewService
    }
    
    public func requestCreateReview(with parameter: ReviewRequestDTO) -> AnyPublisher<ReviewResponseDTO, Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            let publisher = reviewService.requestCreateReview(with: parameter)
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
            
            let publisher = reviewService.requestPrepareUploadURL()
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
            
            let publisher = reviewService.requestUploadImage(
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
}
