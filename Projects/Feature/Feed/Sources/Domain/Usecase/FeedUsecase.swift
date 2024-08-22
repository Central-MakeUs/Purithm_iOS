//
//  FeedUsecase.swift
//  Feed
//
//  Created by 이숭인 on 8/18/24.
//

import Foundation
import Combine
import CoreCommonKit
import CombineExt

public final class FeedUsecase {
    private var cancellables = Set<AnyCancellable>()
    
    private let feedService: FeedServiceManageable
    
    public init(feedService: FeedServiceManageable) {
        self.feedService = feedService
    }
    
    public func reqeustFeeds(with parameter: FeedsRequestDTO) -> AnyPublisher<[FeedsResponseDTO], Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            let publisher = feedService.requestFeeds(with: parameter)
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
    
    public func requestBlock(with reviewID: String) -> AnyPublisher<Void, Error> {
        return Future { [weak self] promise in
            guard let self else { return }
            
            let publisher = feedService.requestBlock(with: reviewID)
                .share()
                .materialize()
            
            publisher.values()
                .sink { response in
                    return promise(.success(()))
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
