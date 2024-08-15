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
    case likeFilter(filterID: String)
    case unlikeFilter(filterID: String)
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
        case .likeFilter(let filterID):
            return "api/filters/\(filterID)/likes"
        case .unlikeFilter(let filterID):
            return "api/filters/\(filterID)/likes"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getFilterList:
            return .get
        case .likeFilter:
            return .post
        case .unlikeFilter:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getFilterList(let requestModel):
            return .requestParameters(parameters: requestModel.toDictionary(), encoding: URLEncoding.queryString)
        case .likeFilter(let filterID):
            let parameters: [String: Any] = ["filterId": filterID]
               return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .unlikeFilter(let filterID):
            let parameters: [String: Any] = ["filterId": filterID]
               return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
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
