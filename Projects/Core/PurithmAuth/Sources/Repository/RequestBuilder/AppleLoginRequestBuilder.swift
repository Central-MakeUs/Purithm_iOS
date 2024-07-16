//
//  AppleLoginRequestBuilder.swift
//  Auth
//
//  Created by 이숭인 on 7/11/24.
//

import Alamofire
import CoreNetwork

final class AppleLoginRequestBuilder: RequestBuilder {
    typealias ResponseType = PurithmTokenResponse
    
    var baseURL: String = ""
    var path: String = ""
    var method: HTTPMethod = .get
    var parameters: Parameters? = nil
}