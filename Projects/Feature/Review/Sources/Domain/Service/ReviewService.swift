//
//  ReviewService.swift
//  Review
//
//  Created by 이숭인 on 8/18/24.
//

import Foundation
import Combine
import Moya
import CombineMoya
import CoreCommonKit

public protocol ReviewServiceManageable {
    func requestCreateReview(with parameter: ReviewCreateRequestDTO) -> AnyPublisher<ResponseWrapper<ReviewCreateResponseDTO>, Error>
    func requestPrepareUploadURL() -> AnyPublisher<ResponseWrapper<PrepareUploadResponseDTO>, Error>
    func requestUploadImage(urlString: String, imageData: Data) -> AnyPublisher<Void, Error>
    func requestLoadReview(with reviewID: String) -> AnyPublisher<ResponseWrapper<ReviewLoadResponseDTO>, Error>
    func requestRemoveReview(with reviewID: String) -> AnyPublisher<ResponseWrapper<EmptyResponseType>, Error>
}

public final class ReviewService: ReviewServiceManageable {
    let provider = MoyaProvider<ReviewAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    public init() { }
    
    public func requestCreateReview(with parameter: ReviewCreateRequestDTO) -> AnyPublisher<ResponseWrapper<ReviewCreateResponseDTO>, Error> {
        provider.requestPublisher(.createReview(parameter: parameter))
            .tryMap { response in
                return try response.map(ResponseWrapper<ReviewCreateResponseDTO>.self)
            }
            .eraseToAnyPublisher()
    }
    
    public func requestPrepareUploadURL() -> AnyPublisher<ResponseWrapper<PrepareUploadResponseDTO>, Error> {
        provider.requestPublisher(.prepareUpload)
            .tryMap { response in
                return try response.map(ResponseWrapper<PrepareUploadResponseDTO>.self)
            }
            .eraseToAnyPublisher()
    }
    
    public func requestUploadImage(urlString: String, imageData: Data) -> AnyPublisher<Void, Error> {
        provider.requestPublisher(.uploadImage(urlString: urlString,
                                               imageData: imageData))
            .tryMap { response in
                return ()
            }
            .eraseToAnyPublisher()
    }
    
    public func requestLoadReview(with reviewID: String) -> AnyPublisher<ResponseWrapper<ReviewLoadResponseDTO>, Error> {
        provider.requestPublisher(.fetchReview(reviewID: reviewID))
            .tryMap { response in
                return try response.map(ResponseWrapper<ReviewLoadResponseDTO>.self)
            }
            .eraseToAnyPublisher()
    }
    
    public func requestRemoveReview(with reviewID: String) -> AnyPublisher<ResponseWrapper<EmptyResponseType>, Error> {
        provider.requestPublisher(.removeReview(reviewID: reviewID))
            .tryMap { response in
                return try response.map(ResponseWrapper<EmptyResponseType>.self)
            }
            .eraseToAnyPublisher()
    }
}
