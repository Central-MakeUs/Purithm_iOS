//
//  AuthorService.swift
//  Author
//
//  Created by 이숭인 on 8/18/24.
//

import Foundation
import Combine
import Moya
import CombineMoya
import CoreCommonKit

public protocol AuthorServiceManageable {
    func requestAuthors(with sorted: AuthorsRequestDTO) -> AnyPublisher<ResponseWrapper<[AuthorsResponseDTO]>, Error>
}

public final class AuthorService: AuthorServiceManageable {
    let provider = MoyaProvider<AuthorAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    public init() { }
    
    public func requestAuthors(with sorted: AuthorsRequestDTO) -> AnyPublisher<ResponseWrapper<[AuthorsResponseDTO]>, Error> {
        provider.requestPublisher(.fetchAuthors(sorted: sorted))
            .tryMap { response in
                return try response.map(ResponseWrapper<[AuthorsResponseDTO]>.self)
            }
            .eraseToAnyPublisher()
    }
}
