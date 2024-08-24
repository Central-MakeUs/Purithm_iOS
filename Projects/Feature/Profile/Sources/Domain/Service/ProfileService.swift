//
//  ProfileService.swift
//  Profile
//
//  Created by 이숭인 on 8/21/24.
//

import Foundation
import Combine
import Moya
import CombineMoya
import CoreCommonKit

public protocol ProfileServiceManageable {
    func requestMyInfomation() -> AnyPublisher<ResponseWrapper<ProfileMyInformationResponseDTO>, Error>
    func requestEditMyInfomation(parameter: ProfileEditRequestDTO) -> AnyPublisher<ResponseWrapper<EmptyResponseType>, Error>
    func requestStampInfomation() -> AnyPublisher<ResponseWrapper<ProfileStamInfomationResponseDTO>, Error>
    func requestAccountInfomation() -> AnyPublisher<ResponseWrapper<ProfileAccountInfomationResponseDTO>, Error>
    func requestMyReviews() -> AnyPublisher<ResponseWrapper<[FeedsResponseDTO]>, Error>
    func requestRemoveReview(with reviewID: String) -> AnyPublisher<ResponseWrapper<EmptyResponseType>, Error>
    func requestMyWishlist() -> AnyPublisher<ResponseWrapper<[ProfileMyWishlistResponseDTO]>, Error>
    func requestFilterAccessHistory() -> AnyPublisher<ResponseWrapper<ProfileFilterAccessHistoryResponseDTO>, Error>
    
    func requestLike(with filterID: String) -> AnyPublisher<ResponseWrapper<Bool>, Error>
    func requestUnlike(with filterID: String) -> AnyPublisher<ResponseWrapper<Bool>, Error>
    
    func requestPrepareUploadURL() -> AnyPublisher<ResponseWrapper<PrepareUploadResponseDTO>, Error>
    func requestUploadImage(urlString: String, imageData: Data) -> AnyPublisher<Void, Error>
}

public final class ProfileService: ProfileServiceManageable {
    let provider = MoyaProvider<ProfileAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    public init() { }
    
    public func requestMyInfomation() -> AnyPublisher<ResponseWrapper<ProfileMyInformationResponseDTO>, Error> {
        provider.requestPublisher(.fetchMyInfomation)
            .tryMap { response in
                return try response.map(ResponseWrapper<ProfileMyInformationResponseDTO>.self)
            }
            .eraseToAnyPublisher()
    }
    
    public func requestAccountInfomation() -> AnyPublisher<ResponseWrapper<ProfileAccountInfomationResponseDTO>, Error> {
        provider.requestPublisher(.fetchAccountInfomation)
            .tryMap { response in
                return try response.map(ResponseWrapper<ProfileAccountInfomationResponseDTO>.self)
            }
            .eraseToAnyPublisher()
    }
    
    public func requestStampInfomation() -> AnyPublisher<ResponseWrapper<ProfileStamInfomationResponseDTO>, Error> {
        provider.requestPublisher(.fetchStampInfomation)
            .tryMap { response in
                return try response.map(ResponseWrapper<ProfileStamInfomationResponseDTO>.self)
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
    
    public func requestMyReviews() -> AnyPublisher<ResponseWrapper<[FeedsResponseDTO]>, Error> {
        provider.requestPublisher(.fetchMyReviews)
            .tryMap { response in
                return try response.map(ResponseWrapper<[FeedsResponseDTO]>.self)
            }
            .eraseToAnyPublisher()
    }
    
    public func requestRemoveReview(with reviewID: String) -> AnyPublisher<ResponseWrapper<EmptyResponseType>, Error> {
        provider.requestPublisher(.removeReview(reviewID: reviewID))
            .tryMap { response in
                return try response.map(ResponseWrapper<EmptyResponseType>.self)
            }
            .eraseToAnyPublisher()
    }
    
    public func requestMyWishlist() -> AnyPublisher<ResponseWrapper<[ProfileMyWishlistResponseDTO]>, Error> {
        provider.requestPublisher(.fetchMyWishlist)
            .tryMap { response in
                return try response.map(ResponseWrapper<[ProfileMyWishlistResponseDTO]>.self)
            }
            .eraseToAnyPublisher()
    }
    
    public func requestFilterAccessHistory() -> AnyPublisher<ResponseWrapper<ProfileFilterAccessHistoryResponseDTO>, Error> {
        provider.requestPublisher(.fetchFilterAccessHistory)
            .tryMap { response in
                return try response.map(ResponseWrapper<ProfileFilterAccessHistoryResponseDTO>.self)
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
    
    public func requestUploadImage(urlString: String, imageData: Data) -> AnyPublisher<Void, Error> {
        provider.requestPublisher(.uploadImage(urlString: urlString,
                                               imageData: imageData))
            .tryMap { response in
                return ()
            }
            .eraseToAnyPublisher()
    }
    
    public func requestEditMyInfomation(parameter: ProfileEditRequestDTO) -> AnyPublisher<ResponseWrapper<EmptyResponseType>, Error> {
        provider.requestPublisher(.editMyInfomation(parameter: parameter))
            .tryMap { response in
                return try response.map(ResponseWrapper<EmptyResponseType>.self)
            }
            .eraseToAnyPublisher()
    }
}
