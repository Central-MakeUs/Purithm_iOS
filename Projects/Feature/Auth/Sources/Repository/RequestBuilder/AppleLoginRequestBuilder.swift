//
//  AppleLoginRequestBuilder.swift
//  Auth
//
//  Created by 이숭인 on 7/11/24.
//

import Alamofire
import NetworkCore

final class AppleLoginRequestBuilder: RequestBuilder {
    typealias ResponseType = EmptyResponseType
    
    var baseURL: String = ""
    var path: String = ""
    var method: HTTPMethod = .get
    var parameters: Parameters? = nil
}
