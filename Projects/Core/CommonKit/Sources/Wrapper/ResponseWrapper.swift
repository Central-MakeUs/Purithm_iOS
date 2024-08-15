//
//  ResponseWrapper.swift
//  CoreCommonKit
//
//  Created by 이숭인 on 8/14/24.
//

import Foundation

public struct ResponseWrapper<ResponseType: Decodable>: Decodable {
    public let code: Int
    public let message: String?
    public let data: ResponseType?
}

public struct EmptyResponseType: Decodable { }
