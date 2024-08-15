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
        provider.requestPublisher(.getFilterList(requestModel: parameter))
            .tryMap { response in
                return try response.map(ResponseWrapper<FilterListResponseDTO>.self)
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
