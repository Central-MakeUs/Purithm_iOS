//
//  FeedAPI.swift
//  Feed
//
//  Created by 이숭인 on 8/18/24.
//

import Foundation
import Moya
import CoreKeychain

enum FeedAPI {
    case fetchFeeds(parameter: FeedsRequestDTO)
}

extension FeedAPI: TargetType {
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
        case .fetchFeeds(let parameter):
            return "api/feeds"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchFeeds:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchFeeds(let parameter):
                .requestParameters(
                    parameters: parameter.toDictionary(),
                    encoding: URLEncoding.queryString
                )
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
