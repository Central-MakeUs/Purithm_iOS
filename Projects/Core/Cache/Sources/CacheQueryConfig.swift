//
//  CacheQueryConfig.swift
//  CacheCore
//
//  Created by DOYEON LEE on 7/7/24.
//

import Foundation

/** 
 ``CacheQuery``를 위한 캐시 정책 설정입니다.

  ``CacheQuery`` 생성자에 `options`로 전달할 수 있습니다.
 */
public enum CacheQueryConfig {
    /// 만료된 캐시를 삭제하는 작업을 TimeInterval마다 실행합니다. 기본값은 5분(60*5)입니다.
    case cleanUpInterval(TimeInterval)
}
