//
//  CommonNetworkError.swift
//  CoreNetwork
//
//  Created by 이숭인 on 7/11/24.
//

import Foundation

public enum CommonNetworkError: Error {
    case unknown
    case invalidURL
    case invalidResponse
    case invalidStatus(code: Int)
    case cancelled
}
