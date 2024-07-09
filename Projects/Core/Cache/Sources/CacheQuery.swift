//
//  CacheQuery.swift
//  CacheCore
//
//  Created by DOYEON LEE on 7/7/24.
//

import Foundation
import OSLog

/**
 비동기 데이터 요청에 대해 메모리 캐시를 적용하기 위한 클래스입니다.
 
 ## 사용법
 캐시 정보를 식별하기 위한 캐시 키를 정의합니다.
 ```swift
 enum FetchQueryKey: CacheQueryKey {
     case image(keyword: String)
     case video(keyword: String)
 }
 ```
 
 캐시 정보를 저장할 CacheQuery 객체를 생성합니다.
 ```swift
let cacheQuery = CacheQuery<FetchQueryKey>()
 ```
 
 실제 데이터 요청 대신, CacheQuery 객체의 캐시 데이터를 이용하기 위해 ``makeQuery(key:expiry:query:)`` 메서드를 사용합니다.
 ```swift
 let fetchQuery = cacheQuery.makeQuery(
    key: .image(keyword: "apple")
 ) {
    // URLSession.shared.dataTask ...
 }
 ```

 생성된 query 클로저를 이용해 실제 데이터 요청을 수행합니다.
 ```swift
 let fetchedData = try await fetchQuery()
 ```
*/
public class CacheQuery<Key: CacheQueryKey> {
    // MARK: Properties
    /// 캐시데이터
    private let cache = NSCache<NSString, NSData>()
    /// Cleanup을 위해 키-만료일 저장
    private var expiryDates = [NSString: Date]()
    /// Cleanup을 수행할 주기
    private var cleanUpInterval: TimeInterval = 60 * 5
    /// Cleanup을 주기마다 수행하기 위한 타이머
    private var timer: Timer?
    
    // MARK: Logger
    private let logger: Logger = Logger(
        subsystem: "",
        category: "CacheQuery"
    )
    
    // MARK: Initializer
    public init(options: [CacheQueryConfig] = []) {
        config(options: options)
        
        DispatchQueue.main.async {
            self.startCleanUpTimer()
        }
    }
    
    /// 만료일과 데이터를 함께 저장하기 위한 구조체입니다.
    private struct CacheEntry<Value: Codable>: Codable {
        let value: Value
        let expiryDate: Date
    }
    
    /// 캐시 기능을 갖춘 쿼리 비동기 클로저를 생성합니다.
    ///
    /// - Parameters:
    ///   - key: 캐시된 데이터를 식별하기 위한 고유값
    ///   - expiry: 캐시가 유효한 시간 간격(단위: 초). 기본값은 5분.
    ///   - query: 캐시가 만료되었거나 없는 경우 실행할 비동기 쿼리
    /// - Returns: 캐시 기능을 갖춘 비동기 요청을 실행할 수 있는 클로저
    public func makeQuery<Value: Codable>(
        key: Key,
        expiry: TimeInterval = 60 * 5, // expiry in seconds
        query: @escaping () async throws -> Value
    ) -> () async throws -> Value {
        return { [weak self] in
            guard let self = self
            else { throw CacheQueryError.instanceAccessError }
            
            let uniqueKey = "\(key.key)"
            let nsKey = NSString(string: uniqueKey)
            
            // 캐시된 데이터가 있는지, 있다면 만료되지 않았는지 확인
            if let cachedData = self.cache.object(forKey: nsKey) as NSData? {
                self.logger.info("Use the cached data. key: \(uniqueKey)")
                let decoder = JSONDecoder()
                do {
                    let cachedEntry = try decoder.decode(CacheEntry<Value>.self, from: cachedData as Data)
                    if cachedEntry.expiryDate > Date() {
                        return cachedEntry.value
                    } else {
                        // 만료된 항목 제거
                        self.cache.removeObject(forKey: nsKey)
                        self.expiryDates.removeValue(forKey: nsKey)
                    }
                } catch {
                    // 디코딩 실패 시, 잘못된 캐시 항목 제거
                    self.cache.removeObject(forKey: nsKey)
                    self.expiryDates.removeValue(forKey: nsKey)
                    throw CacheQueryError.decodingTypeMismatchError
                }
            }
            
            // 쿼리를 실행하고 결과를 캐시
            self.logger.info("Use the query method to fetch new data. key: \(uniqueKey)")
            let result = try await query()
            let expiryDate = Date().addingTimeInterval(TimeInterval(expiry))
            let cacheEntry = CacheEntry(value: result, expiryDate: expiryDate)
            
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(cacheEntry)
            self.cache.setObject(encodedData as NSData, forKey: nsKey)
            self.expiryDates[nsKey] = expiryDate // FIXME: 가끔 접근 에러남
            return result
        }
    }
    
    /// 캐시 정책을 설정하는 메서드입니다.
    private func config(options: [CacheQueryConfig]) {
        options.forEach { option in
            switch option {
            case .cleanUpInterval(let time):
                self.cleanUpInterval = time
            }
        }
    }
    
    /// 만료된 캐시 데이터를 삭제하는 타이머 실행합니다.
    private func startCleanUpTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: cleanUpInterval,
            repeats: true
        ) { [weak self] _ in
            self?.logger.debug("Cleanup the cache")
            self?.cleanUpExpiredCache()
        }
    }
    
    /// 만료된 캐시를 삭제합니다.
    private func cleanUpExpiredCache() {
        let now = Date()
        for (key, expiryDate) in expiryDates where expiryDate <= now {
            cache.removeObject(forKey: key)
            expiryDates.removeValue(forKey: key)
            logger.debug("Removed expired cache for key: \(key)")
        }
    }
}
