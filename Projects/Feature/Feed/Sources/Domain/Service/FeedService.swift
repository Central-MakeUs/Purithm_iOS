//
//  FeedService.swift
//  Feed
//
//  Created by 이숭인 on 8/18/24.
//

import Foundation
import Combine
import Moya
import CombineMoya
import CoreCommonKit

public protocol FeedServiceManageable {
    func requestFeeds(with parameter: FeedsRequestDTO) -> AnyPublisher<ResponseWrapper<[FeedsResponseDTO]>, Error>
    func requestBlock(with reviewID: String) -> AnyPublisher<ResponseWrapper<EmptyResponseType>, Error>
}

public final class FeedService: FeedServiceManageable {
    let provider = MoyaProvider<FeedAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    public init() { }
    
    public func requestFeeds(with parameter: FeedsRequestDTO) -> AnyPublisher<CoreCommonKit.ResponseWrapper<[FeedsResponseDTO]>, any Error> {
        provider.requestPublisher(.fetchFeeds(parameter: parameter))
            .tryMap { response in
                return try response.map(ResponseWrapper<[FeedsResponseDTO]>.self)
            }
            .eraseToAnyPublisher()
    }
    
    public func requestBlock(with reviewID: String) -> AnyPublisher<ResponseWrapper<EmptyResponseType>, Error> {
        provider.requestPublisher(.blockReview(reviewID: reviewID))
            .tryMap { response in
                return try response.map(ResponseWrapper<EmptyResponseType>.self)
            }
            .eraseToAnyPublisher()
    }
}
