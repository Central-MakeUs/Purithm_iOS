//
//  CacheQueryError.swift
//  CacheCore
//
//  Created by DOYEON LEE on 7/7/24.
//

import Foundation

/** CacheQuery 객체에서 발생하는 에러입니다. */
public enum CacheQueryError: LocalizedError {
    /// 캐시 키로 캐시된 데이터와 Decodable 타입이 일치하지 않을 때 발생하는 에러
    case decodingTypeMismatchError
    /// 인스턴스 해제 후 메서드 실행 시 발생하는 에러
    case instanceAccessError
    
    public var errorDescription: String? {
        switch self {
        case .decodingTypeMismatchError:
            return "디코딩 타입 불일치 오류"
        case .instanceAccessError:
            return "인스턴스 접근 오류"
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .decodingTypeMismatchError:
            return "캐시 키로 캐시된 데이터와 Decodable 타입이 일치하지 않습니다."
        case .instanceAccessError:
            return "인스턴스가 해제된 후 메서드가 실행되었습니다."
        }
    }
}
