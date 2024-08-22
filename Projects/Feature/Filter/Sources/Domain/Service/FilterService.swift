//
//  FilterService.swift
//  Filter
//
//  Created by 이숭인 on 8/14/24.
//

import Foundation
import Combine
import Moya
import CombineMoya
import CoreCommonKit

public final class FilterService: FiltersServiceManageable {
    let provider = MoyaProvider<FilterAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    public init() { }
    
    public func requestFilterList(with parameter: FilterListRequestDTO) -> AnyPublisher<ResponseWrapper<FilterListResponseDTO>, Error> {
        provider.requestPublisher(.fetchFilterList(requestModel: parameter))
            .tryMap { response in
                return try response.map(ResponseWrapper<FilterListResponseDTO>.self)
            }
            .eraseToAnyPublisher()
    }
    
    public func requestFilterDetail(with filterID: String) -> AnyPublisher<ResponseWrapper<FilterDetailResponseDTO>, Error> {
        provider.requestPublisher(.fetchFilterDetail(filterID: filterID))
            .tryMap { response in
                return try response.map(ResponseWrapper<FilterDetailResponseDTO>.self)
            }
            .eraseToAnyPublisher()
    }
    
    public func requestFilterAdjustment(with filterID: String) -> AnyPublisher<ResponseWrapper<FilterAdjustmentResponseDTO>, Error> {
        provider.requestPublisher(.fetchFilterAdjustment(filterID: filterID))
            .tryMap { response in
                return try response.map(ResponseWrapper<FilterAdjustmentResponseDTO>.self)
            }
            .eraseToAnyPublisher()
    }
    
    public func requestFilterDescription(with filterID: String) -> AnyPublisher<ResponseWrapper<FilterDescriptionResponseDTO>, Error> {
        provider.requestPublisher(.fetchFilterDescription(filterID: filterID))
            .tryMap { response in
                return try response.map(ResponseWrapper<FilterDescriptionResponseDTO>.self)
            }
            .eraseToAnyPublisher()
    }
    
    public func requestReviewsFromFilter(with filterID: String) -> AnyPublisher<ResponseWrapper<FilterReviewResponseDTO>, Error> {
        provider.requestPublisher(.fetchReviewsFromFilter(filterID: filterID))
            .tryMap { response in
                return try response.map(ResponseWrapper<FilterReviewResponseDTO>.self)
            }
            .eraseToAnyPublisher()
    }
    
    public func requestLike(with filterID: String) -> AnyPublisher<ResponseWrapper<Bool>, Error> {
        provider.requestPublisher(.likeFilter(filterID: filterID))
            .tryMap { response in
                return try response.map(ResponseWrapper<Bool>.self)
            }
            .eraseToAnyPublisher()
    }
    
    public func requestUnlike(with filterID: String) -> AnyPublisher<ResponseWrapper<Bool>, Error> {
        provider.requestPublisher(.unlikeFilter(filterID: filterID))
            .tryMap { response in
                return try response.map(ResponseWrapper<Bool>.self)
            }
            .eraseToAnyPublisher()
    }
}
