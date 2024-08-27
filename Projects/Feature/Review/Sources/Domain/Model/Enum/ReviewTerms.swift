//
//  ReviewTerms.swift
//  Review
//
//  Created by 이숭인 on 8/11/24.
//

import Foundation

enum ReviewTerms: CaseIterable {
    case agree
    case promotionalContentConsent
    
    var title: String {
        switch self {
        case .agree:
            return "(필수) 후기 약관에 동의합니다."
        case .promotionalContentConsent:
            return "(필수) 후기는 홍보 컨텐츠로 사용될 수 있습니다."
        }
    }
}
