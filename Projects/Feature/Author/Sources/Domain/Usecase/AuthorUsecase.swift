//
//  AuthorUsecase.swift
//  Author
//
//  Created by 이숭인 on 8/18/24.
//

import Foundation
import Combine
import CoreCommonKit
import CombineExt

public final class AuthorUsecase {
    private var cancellables = Set<AnyCancellable>()
    
    private let authorService: AuthorServiceManageable
    
    public init(authorService: AuthorServiceManageable) {
        self.authorService = authorService
    }
    
    public func requestAuthors(with parameter: AuthorsRequestDTO) -> AnyPublisher<[AuthorsResponseDTO], Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            let publisher = authorService.requestAuthors(with: parameter)
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
    
    public func requestAuthor(with authorID: String) -> AnyPublisher<AuthorResponseDTO, Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            let publisher = authorService.requestAuthor(with: authorID)
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
    
    public func requestFiltersByAuthor(with parameter: AuthorFiltersRequestDTO) -> AnyPublisher<AuthorFiltersResponseDTO, Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            let publisher = authorService.requestFiltersByAuthor(with: parameter)
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
}
