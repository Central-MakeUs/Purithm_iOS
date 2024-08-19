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
    case createReview(parameter: ReviewRequestDTO)
    case prepareUpload
    case uploadImage(urlString: String, imageData: Data)
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
        case .createReview(let parameter):
            return "api/reviews"
        case .prepareUpload:
            return "api/file"
        case .uploadImage:
            return ""
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

