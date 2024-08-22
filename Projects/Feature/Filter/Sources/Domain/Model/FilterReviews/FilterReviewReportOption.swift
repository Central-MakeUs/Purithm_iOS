//
//  FilterReviewReportOption.swift
//  Filter
//
//  Created by 이숭인 on 8/22/24.
//

import Foundation

public enum FilterReviewReportOption: String, CaseIterable {
    case report
    case block
    
    var identifier: String {
        return self.rawValue
    }
    
    var title: String {
        switch self {
        case .report:
            return "신고하기"
        case .block:
            return "차단하기"
        }
    }
}
