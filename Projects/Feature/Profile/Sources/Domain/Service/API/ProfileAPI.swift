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
    case editMyInfomation(parameter: ProfileEditRequestDTO)
    case fetchAccountInfomation
    case fetchStampInfomation
    
    case fetchMyReviews
    case removeReview(reviewID: String)
    
    case fetchMyWishlist
    case likeFilter(filterID: String)
    case unlikeFilter(filterID: String)
    
    case fetchFilterAccessHistory
    
    case prepareUpload
    case uploadImage(urlString: String, imageData: Data)
}

extension ProfileAPI: TargetType {
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
        case .fetchMyInfomation:
            return "api/users/me"
        case .editMyInfomation:
            return "api/users/me"
        case .fetchAccountInfomation:
            return "api/users/account"
        case .fetchStampInfomation:
            return "api/users/stamps"
        case .fetchMyReviews:
            return "api/users/reviews"
        case .removeReview(let reviewID):
            return "api/users/reviews/\(reviewID)"
        case .fetchMyWishlist:
            return "api/users/picks"
        case .fetchFilterAccessHistory:
            return "api/users/history"
        case .likeFilter(let filterID):
            return "api/filters/\(filterID)/likes"
        case .unlikeFilter(let filterID):
            return "api/filters/\(filterID)/likes"
        case .prepareUpload:
            return "api/file"
        case .uploadImage:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchMyInfomation:
            return .get
        case .editMyInfomation:
            return .post
        case .fetchAccountInfomation:
            return .get
        case .fetchStampInfomation:
            return .get
        case .fetchMyReviews:
            return .get
        case .removeReview:
            return .delete
        case .fetchMyWishlist:
            return .get
        case .fetchFilterAccessHistory:
            return .get
        case .likeFilter:
            return .post
        case .unlikeFilter:
            return .delete
        case .prepareUpload:
            return .post
        case .uploadImage:
            return .put
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchMyInfomation:
            return .requestPlain
        case .editMyInfomation(let parameter):
            return .requestParameters(
                parameters: parameter.toDictionary,
                encoding: JSONEncoding.default
            )
        case .fetchAccountInfomation:
            return .requestPlain
        case .fetchStampInfomation:
            return .requestPlain
        case .fetchMyReviews:
            return .requestPlain
        case .removeReview(let reviewID):
            return .requestParameters(
                parameters: ["reviewId": reviewID],
                encoding: JSONEncoding.default
            )
        case .fetchMyWishlist:
            return .requestPlain
        case .fetchFilterAccessHistory:
            return .requestPlain
        case .likeFilter(let filterID):
            let parameters: [String: Any] = ["filterId": filterID]
               return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .unlikeFilter(let filterID):
            let parameters: [String: Any] = ["filterId": filterID]
               return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .prepareUpload:
            return .requestParameters(
                parameters: ["prefix": "user"],
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

