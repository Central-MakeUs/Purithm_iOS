//
//  PurithmOptionHelpContentType.swift
//  CoreUIKit
//
//  Created by 이숭인 on 8/7/24.
//

import UIKit
import CoreCommonKit

public enum PurithmOptionHelpContentType: CaseIterable {
    case firstStep
    case secondStep
    case thirdStep

    var title: String {
        switch self {
        case .firstStep:
            return "사진첩에서 오른쪽 상단 ‘편집' 버튼 누르기"
        case .secondStep:
            return "가로로 스와이프하며 보정값 적용하기"
        case .thirdStep:
            return "완료 버튼 누르면 완성!"
        }
    }
    
    var image: UIImage {
        switch self {
        case .firstStep:
            return .icNumber1
        case .secondStep:
            return .icNumber2
        case .thirdStep:
            return .icNumber3
        }
    }
    
    var contentImage: UIImage {
        switch self {
        case .firstStep:
            return .firstHelpItem
        case .secondStep:
            return .secondHelpItem
        case .thirdStep:
            return .thirdHelpItem
        }
    }
}
