//
//  ReviewAPI.swift
//  Review
//
//  Created by 이숭인 on 8/18/24.
//

import Foundation
import Moya
import CoreKeychain

enum ReviewAPI {
    case createReview(parameter: ReviewCreateRequestDTO)
    case prepareUpload
    case uploadImage(urlString: String, imageData: Data)
    case fetchReview(reviewID: String)
    case removeReview(reviewID: String)
    
    case fetchFilter(filterID: String)
}

extension ReviewAPI: TargetType {
    private var serviceToken: String { KeychainManager.shared.serviceToken
    }
    
    var baseURL: URL {
        switch self {
        case .uploadImage(let urlString, _):
            return URL(string: urlString)!
        default:
            if let url = URL(string: "https://purithm.shop") {
                return url
            } else {
                fatalError("The BACKEND_ENDPOINT environment variable was not found.")
            }
        }
    }
    
    var path: String {
        switch self {
        case .createReview:
            return "api/reviews"
        case .prepareUpload:
            return "api/file"
        case .uploadImage:
            return ""
        case .fetchReview(let reviewID):
            return "api/reviews/\(reviewID)"
        case .removeReview(let reviewID):
            return "api/users/reviews/\(reviewID)"
        case .fetchFilter(let filterID):
            return "api/filters/\(filterID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createReview:
            return .post
        case .prepareUpload:
            return .post
        case .uploadImage:
            return .put
        case .fetchReview:
            return .get
        case .removeReview:
            return .delete
        case .fetchFilter:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createReview(let parameter):
            return .requestParameters(
                parameters: parameter.toDictionary(),
                encoding: JSONEncoding.default
            )
        case .prepareUpload:
            return .requestParameters(
                parameters: ["prefix": "review"],
                encoding: URLEncoding.queryString
            )
        case .uploadImage(_, let imageData):
            return .requestData(imageData)
        case .fetchReview(let reviewID):
            return .requestParameters(
                parameters: ["reviewId": reviewID],
                encoding: URLEncoding.queryString
            )
        case .removeReview(let reviewID):
            return .requestParameters(
                parameters: ["reviewId": reviewID],
                encoding: JSONEncoding.default
            )
        case .fetchFilter(let filterID):
            return .requestParameters(parameters: ["filterId": filterID], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .uploadImage:
            return ["Content-Type": "image/jpeg"]
        default:
            print("::: filter header > \(serviceToken)")
            return [
                "Authorization": "Bearer \(serviceToken)",
                "Content-type": "application/json"
            ]
        }
    }

}

