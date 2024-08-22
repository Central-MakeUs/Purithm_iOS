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
    case blockReview(reviewID: String)
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
        case .fetchFeeds:
            return "api/feeds"
        case .blockReview:
            return "api/feeds/blocked-feed"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchFeeds:
            return .get
        case .blockReview:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchFeeds(let parameter):
                .requestParameters(
                    parameters: parameter.toDictionary(),
                    encoding: URLEncoding.queryString
                )
        case .blockReview(let reviewID):
                .requestParameters(
                    parameters: ["id": Int(reviewID) ?? .zero],
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
