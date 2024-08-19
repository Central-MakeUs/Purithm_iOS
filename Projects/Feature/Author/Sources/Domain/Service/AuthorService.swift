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
    func requestAuthor(with authorID: String) -> AnyPublisher<ResponseWrapper<AuthorResponseDTO>, Error>
    func requestFiltersByAuthor(with parameter: AuthorFiltersRequestDTO) -> AnyPublisher<ResponseWrapper<AuthorFiltersResponseDTO>, Error>
    func requestLike(with filterID: String) -> AnyPublisher<ResponseWrapper<Bool>, Error>
    func requestUnlike(with filterID: String) -> AnyPublisher<ResponseWrapper<Bool>, Error>
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
    
    public func requestAuthor(with authorID: String) -> AnyPublisher<ResponseWrapper<AuthorResponseDTO>, Error> {
        provider.requestPublisher(.fetchAuthor(authorID: authorID))
            .tryMap { response in
                return try response.map(ResponseWrapper<AuthorResponseDTO>.self)
            }
            .eraseToAnyPublisher()
    }
    
    public func requestFiltersByAuthor(with parameter: AuthorFiltersRequestDTO) -> AnyPublisher<ResponseWrapper<AuthorFiltersResponseDTO>, Error> {
        provider.requestPublisher(.fetchReviewsByAuthor(parameter: parameter))
            .tryMap { response in
                return try response.map(ResponseWrapper<AuthorFiltersResponseDTO>.self)
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
