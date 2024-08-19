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
    func requestCreateReview(with parameter: ReviewRequestDTO) -> AnyPublisher<ResponseWrapper<ReviewResponseDTO>, Error>
    func requestPrepareUploadURL() -> AnyPublisher<ResponseWrapper<PrepareUploadResponseDTO>, Error>
    func requestUploadImage(urlString: String, imageData: Data) -> AnyPublisher<Void, Error>
}

public final class ReviewService: ReviewServiceManageable {
    let provider = MoyaProvider<ReviewAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    public init() { }
    
    public func requestCreateReview(with parameter: ReviewRequestDTO) -> AnyPublisher<ResponseWrapper<ReviewResponseDTO>, Error> {
        provider.requestPublisher(.createReview(parameter: parameter))
            .tryMap { response in
                return try response.map(ResponseWrapper<ReviewResponseDTO>.self)
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
}
