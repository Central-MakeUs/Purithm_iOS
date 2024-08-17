//
//  FilterAdjustmentResponseDTO.swift
//  Filter
//
//  Created by 이숭인 on 8/15/24.
//

import Foundation

public struct FilterAdjustmentResponseDTO: Codable {
    var id: Int
    var thumbnail: String
    var liked: Bool
    var name: String
    var value: FilterValueDTO

    enum CodingKeys: String, CodingKey {
        case id, thumbnail, liked, name, value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail) ?? ""
        liked = try container.decodeIfPresent(Bool.self, forKey: .liked) ?? false
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        value = try container.decodeIfPresent(FilterValueDTO.self, forKey: .value) ?? FilterValueDTO(from: decoder)
    }
}

public struct FilterValueDTO: Codable {
    var exposure: Int
    var luminance: Int
    var highlight: Int
    var shadow: Int
    var contrast: Int
    var brightness: Int
    var blackPoint: Int
    var saturation: Int
    var colorfulness: Int
    var warmth: Int
    var hue: Int
    var clear: Int
    var clarity: Int
    var noise: Int
    
    enum CodingKeys: String, CodingKey {
        case exposure
        case luminance
        case highlight
        case shadow
        case contrast
        case brightness
        case blackPoint = "blackPoint" // 명시적으로 키 이름을 지정
        case saturation
        case colorfulness
        case warmth
        case hue
        case clear
        case clarity
        case noise
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        exposure = try container.decodeIfPresent(Int.self, forKey: .exposure) ?? .zero
        luminance = try container.decodeIfPresent(Int.self, forKey: .luminance) ?? .zero
        highlight = try container.decodeIfPresent(Int.self, forKey: .highlight) ?? .zero
        shadow = try container.decodeIfPresent(Int.self, forKey: .shadow) ?? .zero
        contrast = try container.decodeIfPresent(Int.self, forKey: .contrast) ?? .zero
        brightness = try container.decodeIfPresent(Int.self, forKey: .brightness) ?? .zero
        blackPoint = try container.decodeIfPresent(Int.self, forKey: .blackPoint) ?? .zero
        saturation = try container.decodeIfPresent(Int.self, forKey: .saturation) ?? .zero
        colorfulness = try container.decodeIfPresent(Int.self, forKey: .colorfulness) ?? .zero
        warmth = try container.decodeIfPresent(Int.self, forKey: .warmth) ?? .zero
        hue = try container.decodeIfPresent(Int.self, forKey: .hue) ?? .zero
        clear = try container.decodeIfPresent(Int.self, forKey: .clear) ?? .zero
        clarity = try container.decodeIfPresent(Int.self, forKey: .clarity) ?? .zero
        noise = try container.decodeIfPresent(Int.self, forKey: .noise) ?? .zero
    }
    
    func convertModel() -> [FilterOptionModel] {
        let exposure = FilterOptionModel(
            identifier: IPhonePhotoFilter.exposure.rawValue,
            optionType: .exposure,
            intensity: exposure
        )
        let luminance = FilterOptionModel(
            identifier: IPhonePhotoFilter.luminance.rawValue,
            optionType: .luminance,
            intensity: luminance
        )
        let highlight = FilterOptionModel(
            identifier: IPhonePhotoFilter.highlight.rawValue,
            optionType: .highlight,
            intensity: highlight
        )
        let shadow = FilterOptionModel(
            identifier: IPhonePhotoFilter.shadow.rawValue,
            optionType: .shadow,
            intensity: shadow
        )
        let contrast = FilterOptionModel(
            identifier: IPhonePhotoFilter.contrast.rawValue,
            optionType: .contrast,
            intensity: contrast
        )
        let brightness = FilterOptionModel(
            identifier: IPhonePhotoFilter.brightness.rawValue,
            optionType: .brightness,
            intensity: brightness
        )
        let blackPoint = FilterOptionModel(
            identifier: IPhonePhotoFilter.blackPoint.rawValue,
            optionType: .blackPoint,
            intensity: blackPoint
        )
        let saturation = FilterOptionModel(
            identifier: IPhonePhotoFilter.saturation.rawValue,
            optionType: .saturation,
            intensity: saturation
        )
        let colorfulness = FilterOptionModel(
            identifier: IPhonePhotoFilter.colorSharpness.rawValue,
            optionType: .colorSharpness,
            intensity: colorfulness
        )
        let warmth = FilterOptionModel(
            identifier: IPhonePhotoFilter.warmth.rawValue,
            optionType: .warmth,
            intensity: warmth
        )
        let hue = FilterOptionModel(
            identifier: IPhonePhotoFilter.tint.rawValue,
            optionType: .tint,
            intensity: hue
        )
        let clear = FilterOptionModel(
            identifier: IPhonePhotoFilter.sharpness.rawValue,
            optionType: .sharpness,
            intensity: clear
        )
        let clarity = FilterOptionModel(
            identifier: IPhonePhotoFilter.clarity.rawValue,
            optionType: .clarity,
            intensity: clarity
        )
        let noise = FilterOptionModel(
            identifier: IPhonePhotoFilter.noiseReduction.rawValue,
            optionType: .noiseReduction,
            intensity: noise
        )
        
        return [
            exposure,
            luminance,
            highlight,
            shadow,
            contrast,
            brightness,
            blackPoint,
            saturation,
            colorfulness,
            warmth,
            hue,
            clear,
            clarity,
            noise
        ]
    }
}
