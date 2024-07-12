//
//  AuthManager.swift
//  Auth
//
//  Created by 이숭인 on 7/9/24.
//

import Foundation
import Combine
import Alamofire

private enum AssociatedKeys {
    static var dataRequestWrapperKey: UInt8 = 0
}

public protocol CoreRequestBuilder: NetworkBuilder {
    typealias DataRequestWrapper = Result<DataRequest, CommonNetworkError>

    func request(debug: Bool) -> AnyPublisher<ResponseType, Error>
    func cancel()
}

// MARK: - Variables
extension CoreRequestBuilder {
    private var dataRequestWrapper: DataRequestWrapper {
        if let wrapper = objc_getAssociatedObject(self, &AssociatedKeys.dataRequestWrapperKey) as? DataRequestWrapper {
            return wrapper
        }
        let wrapper = createDataRequestWrapper()
        objc_setAssociatedObject(self, &AssociatedKeys.dataRequestWrapperKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return wrapper
    }
}

// MARK: - request
extension CoreRequestBuilder {
    public func cancel() {
        guard case .success(let dataRequest) = dataRequestWrapper else { return }
        dataRequest.cancel()
    }

    public func request(debug: Bool = false) -> AnyPublisher<ResponseType, Error> {
        return Deferred {
            self.defaultRequest(debug: debug)
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    public func defaultRequest(debug: Bool) -> AnyPublisher<ResponseType, Error> {
        Future<ResponseType, Error> { promise in
            if case .failure(let error) = self.dataRequestWrapper {
                promise(.failure(error))
            }

            guard case .success(let dataRequest) = self.dataRequestWrapper else {
                return promise(.failure(CommonNetworkError.unknown))
            }

            if debug {
                print("Network -> URL(\(self.method.rawValue)) : \(String(describing: dataRequest.convertible.urlRequest?.url))")
                print("Network -> request header : \(String(describing: self.createDefaultHeader()))")
                print("Network -> parameters : \(String(describing: self.parameters))")
            }

            dataRequest.responseData { dataResponse in
                if dataRequest.isCancelled {
                    return promise(.failure(CommonNetworkError.cancelled))
                }

                if let error = dataResponse.error {
                    return promise(.failure(error))
                }

                guard let response = dataResponse.response, let data = dataResponse.data else {
                    return promise(.failure(CommonNetworkError.invalidResponse))
                }

                do {
                    let response = try self.defaultResponse(debug: debug, response: response, data: data)
                    promise(.success(response))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - mockReqeust
extension CoreRequestBuilder {
    /// 주의 \n 은 \\n으로 치환하여 넣어야함
    public func mockRequest(from string: String) -> AnyPublisher<ResponseType, Error> {
        defaultMockRequest(from: string)
    }

    public func defaultMockRequest(from string: String) -> AnyPublisher<ResponseType, Error> {
        guard let data = string.data(using: .utf8, allowLossyConversion: false) else {
            return Fail(error: CommonNetworkError.unknown).eraseToAnyPublisher()
        }

        return Deferred {
            Future<ResponseType, Error> { promise in
                do {
                    let decoded = try self.defaultDecode(from: data)
                    promise(.success(decoded))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

// MARK: - Private Method
extension CoreRequestBuilder {
    private func createDataRequestWrapper() -> DataRequestWrapper {
        guard let convertedURL = createURL() else {
            return .failure(CommonNetworkError.invalidURL)
        }
        let request = networkSession().request(convertedURL,
                                               method: method,
                                               parameters: parameters,
                                               encoding: parameterEncoding,
                                               headers: createDefaultHeader())
        return .success(request)
    }
}

