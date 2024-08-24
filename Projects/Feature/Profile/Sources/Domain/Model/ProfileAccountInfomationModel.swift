//
//  ProfileAccountInfomationModel.swift
//  Profile
//
//  Created by 이숭인 on 8/22/24.
//

import UIKit

extension ProfileAccountInfomationModel {
    enum Method: String {
        case kakao = "카카오 로그인"
        case apple = "애플 로그인"
        
        var logoImage: UIImage {
            switch self {
            case .kakao:
                return .kakaoLogo
            case .apple:
                return .appleLogo
            }
        }
    }
}

struct ProfileAccountInfomationModel {
    let signUpMethod: Method
    var dateOfJoining: String
    let email: String
    
    init(
        signUpMethod: String,
        dateOfJoining: String,
        email: String
    ) {
        self.signUpMethod = Method(rawValue: signUpMethod) ?? .kakao
        self.dateOfJoining = dateOfJoining
        self.email = email
        
        self.dateOfJoining = convertDateFormat(with: dateOfJoining)
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
