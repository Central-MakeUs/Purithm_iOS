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
}
