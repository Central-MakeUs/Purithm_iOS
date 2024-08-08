//
//  PurithmAuthServiceManageable.swift
//  CorePurithmAuth
//
//  Created by 이숭인 on 8/2/24.
//

import Foundation
import Combine

public protocol PurithmAuthServiceManageable {
    func requestTokenValidate(with serviceToken: String) -> AnyPublisher<ResponseWrapper<EmptyResponseType>, Error>
    func requestKakaoSignIn(with accessToken: String) -> AnyPublisher<ResponseWrapper<PurithmTokenResponseDTO>, Error>
    func requestAppleSignIn(with parameter: [String: Any], token: String) -> AnyPublisher<ResponseWrapper<PurithmTokenResponseDTO>, Error>
    func requestTermsConform(with serviceToken: String) -> AnyPublisher<ResponseWrapper<EmptyResponseType>, Error>
}
