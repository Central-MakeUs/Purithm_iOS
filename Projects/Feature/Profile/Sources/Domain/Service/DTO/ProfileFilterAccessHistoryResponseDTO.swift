//
//  ProfileFilterAccessHistoryResponseDTO.swift
//  Profile
//
//  Created by 이숭인 on 8/23/24.
//

import Foundation

public struct ProfileFilterAccessHistoryResponseDTO: Codable {
    let totalCount: Int
    let list: [FilterHistory]
}

struct FilterHistory: Codable {
    var date: String
    let filters: [Filter]
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(String.self, forKey: .date)
        self.filters = try container.decode([Filter].self, forKey: .filters)
        
        self.date = convertDateFormat(with: date)
    }
    
    private func convertDateFormat(with date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // 날짜 포맷에 대한 로케일 설정

        if let date = dateFormatter.date(from: date) {
            // Date 객체를 원하는 형식의 문자열로 변환
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy.MM.dd"
            let formattedDateString = outputFormatter.string(from: date)
            
            return formattedDateString
        } else {
            return date
        }
    }
}

struct Filter: Codable {
    let filterId: Int
    let filterName: String
    let photographer: String
    let membership: String
    let createdAt: String
    let hasReview: Bool
    let reviewId: Int
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.filterId = try container.decode(Int.self, forKey: .filterId)
        self.filterName = try container.decode(String.self, forKey: .filterName)
        self.photographer = try container.decode(String.self, forKey: .photographer)
        self.membership = try container.decode(String.self, forKey: .membership)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.hasReview = try container.decode(Bool.self, forKey: .hasReview)
        self.reviewId = try container.decodeIfPresent(Int.self, forKey: .reviewId) ?? .zero
    }
}
