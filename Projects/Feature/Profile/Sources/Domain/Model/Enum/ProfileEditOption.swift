//
//  ProfileEditOption.swift
//  Profile
//
//  Created by 이숭인 on 8/26/24.
//

import Foundation

public enum ProfileEditOption: String, CaseIterable {
    case openGallery
    case setGeneral
    
    var identifier: String {
        return self.rawValue
    }
    
    var title: String {
        switch self {
        case .openGallery:
            return "사진첩에서 선택"
        case .setGeneral:
            return "기본 이미지로 변경"
        }
    }
}
