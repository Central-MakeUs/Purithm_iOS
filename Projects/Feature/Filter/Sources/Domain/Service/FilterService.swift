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
}
