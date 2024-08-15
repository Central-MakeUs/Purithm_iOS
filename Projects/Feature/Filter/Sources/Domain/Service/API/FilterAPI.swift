//
//  FilterAPI.swift
//  Filter
//
//  Created by 이숭인 on 8/14/24.
//

import Foundation
import Moya
import CoreKeychain

enum FilterAPI {
    case getFilterList(requestModel: FilterListRequestDTO)
}

extension FilterAPI: TargetType {
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
        case .getFilterList:
            return "api/filters"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getFilterList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getFilterList(let requestModel):
            return .requestParameters(parameters: requestModel.toDictionary(), encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getFilterList:
            print("::: filter header > \(serviceToken)")
            return [
                "Authorization": "Bearer \(serviceToken)",
                "Content-type": "application/json"
            ]
        }
    }
}
