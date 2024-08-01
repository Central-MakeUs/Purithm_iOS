//
//  AuthAPI.swift
//  CorePurithmAuth
//
//  Created by 이숭인 on 8/1/24.
//

import Foundation
import Moya

public struct ResponseWrapper<ResponseType: Decodable>: Decodable {
    public let code: Int
    public let message: String?
    public let data: ResponseType?
}

public struct EmptyResponseType: Decodable { }

enum AuthAPI {
    case validateToken(serviceToken: String)
    case appleSignIn(parameter: AppleSignInRequestModel, token: String)
    case kakaoSignIn(kakaoAccessToken: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        if let url = URL(string: "https://purithm.shop") {
            return url
        } else {
            fatalError("The BACKEND_ENDPOINT environment variable was not found.")
        }
    }
    
    var path: String {
        switch self {
        case .validateToken:
            return "/api"
        case .appleSignIn:
            return "/auth/apple"
        case .kakaoSignIn:
            return "/auth/kakao"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .validateToken:
            return .get
        case .appleSignIn, .kakaoSignIn:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .validateToken:
            return .requestPlain
        case .kakaoSignIn:
            return .requestPlain
        case .appleSignIn(let requestModel, _):
            return .requestJSONEncodable(requestModel)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .validateToken(let serviceToken):
            return [
                "Authorization": "Bearer \(serviceToken)",
                "Content-type": "application/json"
            ]
        case .kakaoSignIn(let kakaoAccessToken):
            return [
                "Authorization": "Bearer \(kakaoAccessToken)",
                "Content-type": "application/json"
            ]
        case .appleSignIn(let parameter, let identifierToken):
            return [
                "Authorization": "Bearer \(identifierToken)",
                "Content-type": "application/json"
            ]
        }
    }
}
