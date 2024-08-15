//
//  FiltersUseCase.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import Foundation
import Combine
import CoreCommonKit
import CombineExt

public protocol FiltersServiceManageable {
    func requestFilterList(with parameter: FilterListRequestDTO) -> AnyPublisher<ResponseWrapper<FilterListResponseDTO>, Error>
    func requestLike(with filterID: String) -> AnyPublisher<ResponseWrapper<Bool>, Error>
    func requestUnlike(with filterID: String) -> AnyPublisher<ResponseWrapper<Bool>, Error>
}

public final class FiltersUseCase {
    private var cancellables = Set<AnyCancellable>()
    
    private let filterService: FiltersServiceManageable
    
    public init(filterService: FiltersServiceManageable) {
        self.filterService = filterService
    }
    
    public func requestFilterList(with parameter: FilterListRequestDTO) -> AnyPublisher<FilterListResponseDTO, Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            let publisher = filterService.requestFilterList(with: parameter)
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
    
    public func requestLike(with filterID: String) -> AnyPublisher<Bool, Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            let publisher = filterService.requestLike(with: filterID)
                .share()
                .materialize()
            
            publisher.values()
                .sink { response in
                    guard let data = response.data else { return }
                    
                    return promise(.success(data))
                }
                .store(in: &cancellables)
            
            publisher.failures()
                .sink { _ in } receiveValue: { error in
                    return promise(.failure(error))
                }
                .store(in: &cancellables)

            
        }
        .eraseToAnyPublisher()
    }
    
    public func requestUnlike(with filterID: String) -> AnyPublisher<Bool, Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            let publisher = filterService.requestUnlike(with: filterID)
                .share()
                .materialize()
            
            publisher.values()
                .sink { response in
                    guard let data = response.data else { return }
                    
                    return promise(.success(data))
                }
                .store(in: &cancellables)
            
            publisher.failures()
                .sink { _ in } receiveValue: { error in
                    return promise(.failure(error))
                }
                .store(in: &cancellables)

            
        }
        .eraseToAnyPublisher()
    }
}
