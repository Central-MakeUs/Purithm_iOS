//
//  ProfileAPI.swift
//  Profile
//
//  Created by 이숭인 on 8/21/24.
//

import Foundation
import Moya
import CoreKeychain

enum ProfileAPI {
    case fetchMyInfomation
}

extension ProfileAPI: TargetType {
    private var serviceToken: String { KeychainManager.shared.serviceToken
    }
    
    var baseURL: URL {
        if let url = URL(string: "https://purithm.shop") {
            return url
        } else {
            fatalError("The BACKEND_ENDPOINT environment variable was not found.")
        }
    }
    
    var path: String {
        switch self {
        case .fetchMyInfomation:
            "api/users/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchMyInfomation:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchMyInfomation:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            print("::: filter header > \(serviceToken)")
            return [
                "Authorization": "Bearer \(serviceToken)",
                "Content-type": "application/json"
            ]
        }
    }
}
