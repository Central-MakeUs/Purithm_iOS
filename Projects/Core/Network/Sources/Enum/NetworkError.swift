//
//  NetworkError.swift
//  CoreNetwork
//
//  Created by 이숭인 on 7/11/24.
//

import Foundation


public enum NetworkError: Int, Error, CaseIterable {
    /// 정상 처리되었습니다.
    case success = 20000
    /// 정상 처리되었습니다. (유저 생성 성공)
    case successUserSignIn = 20400
    /// 적절하지 않은 요청입니다.
    case unauthorized = 40000
    /// 지원하지 않는 OS 기종입니다.
    case unsupportedOS = 40001
    /// 유효하지 않은 토큰입니다./
    case invalidToken = 40100
    /// 만료된 토큰입니다./
    case expiredToken = 40101
    /// 이용약관 동의가 필요합니다.
    case termsOfServiceRequired = 40300
    /// 리소스를 찾을 수 없습니다./
    case resourceNotFound = 40400
    /// 이미 사용 중인 닉네임입니다./
    case nicknameAlreadyInUse = 40900
    /// 서버 에러가 발생했습니다./
    case serverError = 50000
    /// 외부 API와 통신에 실패했습니다./
    case externalAPIFailure = 50001
    /// 존재하지 않는 요청입니다./
    case invalidRequest = 40500
    /// 잘못된 서버 응답 코드입니다.
    case invalidErrorType = 99999

    var localizedDescription: String {
        switch self {
        case .success:
            return "정상 처리되었습니다."
        case .successUserSignIn:
            return "정상 처리되었습니다. (유저 가입 성공)"
        case .unauthorized:
            return "적절하지 않은 요청입니다."
        case .unsupportedOS:
            return "지원하지 않는 OS 기종입니다."
        case .invalidToken:
            return "유효하지 않은 토큰입니다."
        case .expiredToken:
            return "만료된 토큰입니다."
        case .termsOfServiceRequired:
            return "이용약관 동의가 필요합니다."
        case .resourceNotFound:
            return "리소스를 찾을 수 없습니다."
        case .nicknameAlreadyInUse:
            return "이미 사용 중인 닉네임입니다."
        case .serverError:
            return "서버 에러가 발생했습니다."
        case .externalAPIFailure:
            return "외부 API와 통신에 실패했습니다."
        case .invalidRequest:
            return "존재하지 않는 요청입니다."
        case .invalidErrorType:
            return "잘못된 서버 에러타입 입니다."
        }
    }
}
