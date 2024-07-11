//
//  RequestBuilder.swift
//  NetworkCore
//
//  Created by 이숭인 on 7/11/24.
//

import Foundation
import Combine
import Alamofire
import Foundation

public protocol RequestBuilder: CoreRequestBuilder { }

// MARK: - request
extension RequestBuilder {
    public func request(debug: Bool = false) -> AnyPublisher<ResponseType, Error> {
        return Deferred {
            Just(Void()).eraseToAnyPublisher()
                .flatMap {
                    self.defaultRequest(debug: debug)
                }
        }
        .catch { error in
            //TODO: ERROR Handle
            Fail(error: error).eraseToAnyPublisher()
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    public func defaultDecode(from data: Data) throws -> ResponseType {
        if let decoded = try? jsonDecoder().decode(ResponseWrapper<EmptyResponseType>.self, from: data) {
            if let error = NetworkError(rawValue: decoded.code) {
                //TODO: Error Handle
                throw error
            }
        }

        return try decode(from: data)
    }

    public func decode(from data: Data) throws -> ResponseType {
        let decoded = try jsonDecoder().decode(ResponseWrapper<ResponseType>.self, from: data)

        if let data = decoded.data {
            return data
        } else {
            throw CommonNetworkError.invalidResponse
        }
    }
}

// MARK: - mockRequest
extension RequestBuilder {
    public func mockRequest(from string: String) -> AnyPublisher<ResponseType, Error> {
        defaultMockRequest(from: string)
            .catch { error in
                Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
