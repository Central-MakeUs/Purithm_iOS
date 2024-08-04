//
//  PurithmAuthService.swift
//  CorePurithmAuth
//
//  Created by 이숭인 on 8/2/24.
//

import Foundation
import Combine
import Moya
import CombineMoya

public final class PurithmAuthService: PurithmAuthServiceManageable {
    let provider = MoyaProvider<AuthAPI>()
    
    public init() { }
    
    public func requestTokenValidate(with serviceToken: String) -> AnyPublisher<ResponseWrapper<EmptyResponseType>, Error> {
        provider.requestPublisher(.validateToken(serviceToken: serviceToken))
            .tryMap { response in
                return try response.map(ResponseWrapper<EmptyResponseType>.self)
            }
            .eraseToAnyPublisher()
    }
    
    public func requestKakaoSignIn(with accessToken: String) -> AnyPublisher<ResponseWrapper<PurithmTokenResponseDTO>, Error> {
        provider.requestPublisher(.kakaoSignIn(kakaoAccessToken: accessToken))
            .tryMap { response in
                return try response.map(ResponseWrapper<PurithmTokenResponseDTO>.self)
            }
            .eraseToAnyPublisher()
    }
    
    public func requestAppleSignIn(with parameter: [String: Any], token: String) -> AnyPublisher<ResponseWrapper<PurithmTokenResponseDTO>, Error> {
        provider.requestPublisher(.appleSignIn(parameter: parameter, token: token))
            .tryMap { response in
                return try response.map(ResponseWrapper<PurithmTokenResponseDTO>.self)
            }
            .eraseToAnyPublisher()
    }
    
    public func requestTermsConform(with serviceToken: String) -> AnyPublisher<ResponseWrapper<EmptyResponseType>, Error> {
        provider.requestPublisher(.conformTerms(serviceToken: serviceToken))
            .tryMap { response in
                return try response.map(ResponseWrapper<EmptyResponseType>.self)
            }
            .eraseToAnyPublisher()
    }
}
