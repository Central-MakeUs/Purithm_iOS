//
//  IPhoneFilterType.swift
//  Filter
//
//  Created by 이숭인 on 8/6/24.
//

import UIKit
import CoreCommonKit

enum IPhonePhotoFilter: String, CaseIterable {
    case exposure
    case brightness
    case highlight
    case shadow
    case contrast
    case luminance
    case blackPoint
    case saturation
    case colorSharpness = "colorfulness"
    case warmth
    case tint = "hue"
    case sharpness = "clear"
    case clarity
    case noiseReduction = "noise"
    case vignette
    
    var title: String {
        switch self {
        case .exposure:
            return "노출"
        case .brightness:
            return "밝기"
        case .highlight:
            return "하이라이트"
        case .shadow:
            return "그림자"
        case .contrast:
            return "대비"
        case .luminance:
            return "휘도"
        case .blackPoint:
            return "블랙포인트"
        case .saturation:
            return "채도"
        case .colorSharpness:
            return "색 선명도"
        case .warmth:
            return "따뜻함"
        case .tint:
            return "색조"
        case .sharpness:
            return "선명도"
        case .clarity:
            return "명료도"
        case .noiseReduction:
            return "노이즈 감소"
        case .vignette:
            return "비네트"
        }
    }
    
    var image: UIImage {
        switch self {
        case .exposure:
            return .icExposure
        case .brightness:
            return .icBrightness
        case .highlight:
            return .icHighlight
        case .shadow:
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
