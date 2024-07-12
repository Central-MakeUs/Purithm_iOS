//
//  NetworkBuilder.swift
//  CoreNetwork
//
//  Created by 이숭인 on 7/11/24.
//
import Foundation
import Alamofire

public typealias HTTPHeaderType = [String: String]

public protocol NetworkBuilder: AnyObject {
    associatedtype ResponseType: Decodable

    var method: HTTPMethod { get }
    var header: HTTPHeaders? { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var parameterEncoding: ParameterEncoding { get }
    var additionalHeader: HTTPHeaderType? { get }
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }

    func networkSession() -> Session
    func defaultDecode(from data: Data) throws -> ResponseType
    func decode(from data: Data) throws -> ResponseType
}

public extension NetworkBuilder {
    var header: HTTPHeaders? { nil }
    var parameterEncoding: ParameterEncoding {
        switch method {
        case .get:
            URLEncoding.default
        default:
            JSONEncoding.default
        }
    }
    var additionalHeader: HTTPHeaderType? { nil }
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { .iso8601 }
}

public extension NetworkBuilder {
    func decode(from data: Data) throws -> ResponseType {
        try jsonDecoder().decode(ResponseType.self, from: data)
    }

    func jsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        return decoder
    }

    func networkSession() -> Session {
        Session.default
    }
}

extension NetworkBuilder {
    func createURL() -> URL? {
        (baseURL + path).toURL
    }

    func createDefaultHeader() -> HTTPHeaders {
        var defaultHeader: HTTPHeaders = .default

        header?.makeIterator().forEach {
            defaultHeader.update($0)
        }

        additionalHeader?.forEach { (key, value) in
            defaultHeader.update(name: key, value: value)
        }

        return defaultHeader
    }
}

extension NetworkBuilder {
    func defaultResponse(debug: Bool, response: HTTPURLResponse, data: Data) throws -> ResponseType {
        if debug {
            print("Network -> response : \(response)")
            print("Network -> \(String(decoding: data, as: UTF8.self))")
        }

        do {
            return try defaultDecode(from: data)
        } catch {
            throw error
        }
    }

    func defaultDecode(from data: Data) throws -> ResponseType {
        try decode(from: data)
    }
}



extension String {
    public var toURL: URL? {
        if !isEscaped(), let encoded = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return URL(string: encoded)
        } else {
            return URL(string: self)
        }
    }
    
    private func isEscaped() -> Bool {
        removingPercentEncoding != self
    }
}
