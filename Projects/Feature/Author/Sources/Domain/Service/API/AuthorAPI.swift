//
//  AuthorAPI.swift
//  Author
//
//  Created by 이숭인 on 8/18/24.
//

import Foundation
import Moya
import CoreKeychain

enum AuthorAPI {
    case fetchAuthors(sorted: AuthorsRequestDTO)
    case fetchAuthor(authorID: String)
    case fetchReviewsByAuthor(parameter: AuthorFiltersRequestDTO)
}

extension AuthorAPI: TargetType {
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
        case .fetchAuthors:
            return "api/photographers"
        case .fetchAuthor(let authorID):
            return "api/photographers/\(authorID)"
        case .fetchReviewsByAuthor(let parameter):
            return "api/photographers/\(parameter.authorID)/filters"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchAuthors:
            return .get
        case .fetchAuthor:
            return .get
        case .fetchReviewsByAuthor:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchAuthors(let sorted):
                .requestParameters(
                    parameters: sorted.toDictionary(),
                    encoding: URLEncoding.queryString
                )
        case .fetchAuthor(let authorID):
                .requestParameters(parameters: ["photographerId": authorID], encoding: URLEncoding.queryString)
        case .fetchReviewsByAuthor(let parameter):
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
