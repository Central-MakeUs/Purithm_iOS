//
//  PurithmHeaderType.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/6/24.
//

import Foundation

public enum PurithmHeaderType {
    case back(title: String, likeCount: Int, isLike: Bool)
    case close(title: String, isLike: Bool)
}
