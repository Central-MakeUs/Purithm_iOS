//
//  FilterReviewItemModel.swift
//  Filter
//
//  Created by 이숭인 on 8/5/24.
//

import Foundation
import CoreCommonKit

struct FilterReviewItemModel {
    let identifier: String
    let thumbnailImageURLString: String
    let author: String
    var date: String
    let satisfactionLevel: SatisfactionLevel
    
    init(identifier: String, thumbnailImageURLString: String, author: String, date: String, satisfactionLevel: SatisfactionLevel) {
        self.identifier = identifier
        self.thumbnailImageURLString = thumbnailImageURLString
        self.author = author
        self.date = date
        self.satisfactionLevel = satisfactionLevel
        
        //update dateformat
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
