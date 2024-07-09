//
//  CacheQueryKey.swift
//  CacheCore
//
//  Created by DOYEON LEE on 7/7/24.
//

import Foundation

/** 
 캐시 키를 위한 enum을 생성할 때 사용하는 프로토콜입니다.
 
 요청을 식별할 수 있는 enum을 정의함으로써 해당 요청에 대한 고유한 키값을 보장할 수 있습니다.
 
 ```swift
enum FetchQueryKey: CacheQueryKey {
    case image(keyword: String)
    case video(keyword: String)
}
```
*/
public protocol CacheQueryKey {
    var key: String { get }
}

public extension CacheQueryKey {
    var key: String {
        return "\(type(of: self))_\(self)"
            .replacingOccurrences(of: " ", with: "_")
    }
}
