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
    case fetchFilterList(requestModel: FilterListRequestDTO)
    case fetchFilterDetail(filterID: String)
    case fetchFilterAdjustment(filterID: String)
    case fetchFilterDescription(filterID: String)
    case fetchReviewsFromFilter(filterID: String)
    case likeFilter(filterID: String)
    case unlikeFilter(filterID: String)
    
    case blockReview(reviewID: String)
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
        case .fetchFilterList:
            return "api/filters"
        case .fetchFilterDetail(let filterID):
            return "api/filters/\(filterID)"
        case .fetchFilterAdjustment(let filterID):
            return "api/filters/\(filterID)/iOS"
        case .fetchFilterDescription(let filterID):
            return "api/filters/\(filterID)/descriptions"
        case .fetchReviewsFromFilter(let filterID):
            return "api/filters/\(filterID)/reviews"
        case .likeFilter(let filterID):
            return "api/filters/\(filterID)/likes"
        case .unlikeFilter(let filterID):
            return "api/filters/\(filterID)/likes"
        case .blockReview:
            return "api/feeds/blocked-feed"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchFilterList:
            return .get
        case .fetchFilterDetail:
            return .get
        case .fetchFilterAdjustment:
            return .get
        case .fetchFilterDescription:
            return .get
        case .fetchReviewsFromFilter:
            return .get
        case .likeFilter:
            return .post
        case .unlikeFilter:
            return .delete
        case .blockReview:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchFilterList(let requestModel):
            return .requestParameters(parameters: requestModel.toDictionary(), encoding: URLEncoding.queryString)
        case .fetchFilterDetail(let filterID):
            return .requestParameters(parameters: ["filterId": filterID], encoding: URLEncoding.queryString)
        case .fetchFilterAdjustment(let filterID):
            return .requestParameters(parameters: ["filterId": filterID], encoding: URLEncoding.queryString)
        case .fetchFilterDescription(let filterID):
            return .requestParameters(parameters: ["filterId": filterID], encoding: URLEncoding.queryString)
        case .fetchReviewsFromFilter(let filterID):
            return .requestParameters(parameters: ["filterId": filterID], encoding: URLEncoding.queryString)
        case .likeFilter(let filterID):
            let parameters: [String: Any] = ["filterId": filterID]
               return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .unlikeFilter(let filterID):
            let parameters: [String: Any] = ["filterId": filterID]
               return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .blockReview(let reviewID):
            let parameters: [String: Any] = ["id": Int(reviewID) ?? .zero]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
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
