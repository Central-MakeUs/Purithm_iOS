//
//  IPhoneFilterType.swift
//  Filter
//
//  Created by 이숭인 on 8/6/24.
//

import UIKit
import CoreCommonKit

enum IPhonePhotoFilter: String, CaseIterable {
    case exposure = "노출"
    case brightness = "휘도"
    case highlights = "하이라이트"
    case shadows = "그림자"
    case contrast = "대비"
    case luminance = "밝기"
    case blackPoint = "블랙포인트"
    case saturation = "채도"
    case colorSharpness = "색 선명도"
    case warmth = "따뜻함"
    case tint = "색조"
    case sharpness = "선명도"
    case clarity = "명료도"
    case noiseReduction = "노이즈 감소"
    case vignette = "비네트"
    
    var image: UIImage {
        switch self {
        case .exposure:
            return .icExposure
        case .brightness:
            return .icBrightness
        case .highlights:
            return .icHighlight
        case .shadows:
            return .icShadow
        case .contrast:
            return .icContrast
        case .luminance:
            return .icLightness
        case .blackPoint:
            return .icBlackpoint
        case .saturation:
            return .icSaturation
        case .colorSharpness:
            return .icColorSharpness
        case .warmth:
            return .icWarming
        case .tint:
            return .icHue
        case .sharpness:
            return .icSharpness
        case .clarity:
            return .icClarity
        case .noiseReduction:
            return .icDenoise
        case .vignette:
            return .icVignette
        }
    }
}
